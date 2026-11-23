# Volet 1 — la plateforme Wazuh

**Auteur :** Ouzziki Lhoussaine
**Branche :** `workshop6-wazuh-plateforme-lhoussaine`
**Réalisé le :** 2026-11-23
**Objectif tenu :** la stack Wazuh tourne sur une machine, un agent est enrôlé et `Active`, et ses
événements remontent jusqu'au dashboard avec leurs identifiants de règle.

---

## 1. Prérequis

| Élément | Valeur constatée | Minimum conseillé |
|---|---|---|
| Processeurs | 8 | 2 |
| Mémoire | 14 Gi (5.6 Gi réellement libres avant déploiement) | 8 Gi, dont 4 à 5 libres |
| Disque libre | 64 G | 20 G |
| Système | Ubuntu 26.04.1 LTS, noyau 7.0.0-43-generic | n'importe quelle distribution avec Docker |
| Docker | 29.10.0 (build `fdd4b8e`) | version avec le plugin `docker compose` |
| Docker Compose | v5.7.0 (plugin) | `docker compose`, pas `docker-compose` |

**Le prérequis qui bloque tout le monde** : `vm.max_map_count` doit valoir **262144**. Sans cela,
l'indexer refuse de démarrer. La valeur par défaut d'Ubuntu est 65530.

```bash
sysctl -n vm.max_map_count
sudo sysctl -w vm.max_map_count=262144
echo "vm.max_map_count=262144" | sudo tee /etc/sysctl.d/99-wazuh.conf
```

La deuxième ligne règle la valeur pour la session en cours ; la troisième la rend **permanente**.
C'est la troisième qui compte : après un redémarrage, seul le fichier `/etc/sysctl.d/` est relu.

## 2. Architecture déployée

Trois briques, chacune dans son conteneur, sur un seul hôte :

```
agent (cible-ssh-01)
        │  1514/tcp (données)  ·  1515/tcp (enrôlement)
        ▼
   manager 4.14.10  ──►  indexer 4.14.10  ──►  dashboard 4.14.10
   (règles,          (9200, stockage        (443, navigateur)
    analyses)         des alertes)
```

- le **manager** reçoit les journaux, applique les décodeurs et les règles, produit des alertes ;
- l'**indexer** stocke les alertes et les inventaires ;
- le **dashboard** interroge l'indexer et affiche.

### Ports utilisés

| Port | Rôle | Exposé sur l'hôte ? | Pourquoi |
|---|---|---|---|
| `1514/tcp` | réception des données des agents | oui (`0.0.0.0`) | indispensable : les agents peuvent être sur d'autres machines |
| `1515/tcp` | enrôlement des agents | oui (`0.0.0.0`) | indispensable au premier enregistrement |
| `1517/tcp` | enrôlement en **5.0** | **absent en 4.14** | port de la version 5, retiré après la bascule — voir §7 |
| `55000/tcp` | API Wazuh | oui (`0.0.0.0`) | utilisée par le dashboard ; **à restreindre en production** |
| `443/tcp` | dashboard | oui (`0.0.0.0`) | accès navigateur ; **devrait être limité à la boucle locale en laboratoire** |
| `9200/tcp` | indexer | oui (`0.0.0.0`) | **n'a aucune raison d'être exposé** : seul le manager et le dashboard y accèdent, sur le réseau Docker interne |
| `514/udp` | syslog entrant | oui (`0.0.0.0`) | activé par le compose officiel, **non utilisé** dans ce laboratoire |

**Trois de ces expositions sont des constats de sécurité à assumer** : `9200`, `55000` et `443` sont
joignables depuis le réseau local alors qu'aucune machine extérieure n'en a besoin. En production, on
les lierait à `127.0.0.1` dans le compose (`- 127.0.0.1:443:5601`).

## 3. Procédure réellement suivie

```bash
# 1. épingler la version (le clone par défaut pointe sur la 5.0)
cd ~/wazuh-docker
git fetch --tags
git checkout v4.14.10

# 2. préparer les certificats (le générateur écrit dans config/wazuh_indexer_ssl_certs/)
cd single-node
docker compose -f generate-indexer-certs.yml run --rm generator

# 3. démarrer
docker compose up -d
docker compose ps          # attendre que les trois services soient « Up »

# 4. vérifier que le manager parle à l'indexer
docker compose logs --tail=30 wazuh.manager | grep -i "connection to backoff"
```

Le manager **échoue volontairement** ses premières tentatives (`connection refused`) : l'indexer met
environ 40 secondes à ouvrir son port, alors que Filebeat démarre immédiatement. Au bout de quelques
essais, il affiche `Connection to backoff(elasticsearch(https://wazuh.indexer:9200)) established`.
**Ce n'est pas une erreur** : c'est la séquence de démarrage normale.

Puis l'agent, installé depuis le paquet officiel aligné sur la version du manager :

```bash
wget -O /tmp/wazuh-agent_4.14.10-1_amd64.deb \
  https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.14.10-1_amd64.deb
sudo WAZUH_MANAGER='192.168.0.126' WAZUH_AGENT_NAME='cible-ssh-01' \
  dpkg -i /tmp/wazuh-agent_4.14.10-1_amd64.deb
sudo systemctl daemon-reload
sudo systemctl enable --now wazuh-agent
```

`WAZUH_AGENT_NAME` est fixé **au moment de l'installation** : ce nom apparaîtra ensuite dans chaque
alerte. L'agent doit impérativement être de la **même version** que le manager.

## 4. Redémarrage propre

L'ordre compte moins que la vérification finale, mais il faut savoir quoi regarder :

```bash
# après un redémarrage de la machine
sysctl -n vm.max_map_count                 # doit valoir 262144 (sinon l'indexer refuse de démarrer)
cd ~/wazuh-docker/single-node && docker compose ps
docker compose logs --tail=20 wazuh.manager | grep -i "connection to backoff"
sudo systemctl is-active wazuh-agent
```

L'agent est `enabled` : il repart tout seul. La stack est `restart: always` dans le compose : elle
repart aussi, à condition que Docker démarre avec le système.

**Ne jamais faire `docker compose down -v`** pour « repartir propre » : le `-v` supprime les volumes,
donc les données de l'indexer et les certificats générés. Si la stack est cassée, on inspecte les logs
avant de détruire.

## 5. Certificat auto-signé

Le navigateur affiche « Not secure » sur `https://localhost`. C'est attendu : les certificats sont
générés localement par `generate-indexer-certs.yml`, aucune autorité de certification publique ne les
valide. La conséquence pratique est qu'il faut accepter l'exception à chaque nouvel accès. En
production, on utiliserait un certificat signé par une autorité reconnue, ou une PKI interne.

## 6. Mot de passe du dashboard — état réel

**Le mot de passe par défaut n'a pas été changé à l'issue de ce volet.** Valeur non consignée ici,
conformément à la règle du workshop.

Conséquences, assumées et à corriger avant toute mise en production :

1. Les identifiants sont **publics** : ce sont les valeurs par défaut du dépôt officiel.
2. Le dashboard écoute sur `0.0.0.0:443` : **toute machine du réseau local peut s'y connecter**.
3. Le mot de passe figure en clair dans `single-node/docker-compose.yml`, aux lignes 22 et 79. Ce
   fichier appartient au clone de `wazuh-docker` et **n'a jamais été versionné dans le dépôt du groupe**.

**Trois emplacements doivent rester synchronisés** lors d'un changement : l'indexer (qui détient
l'empreinte du mot de passe), la ligne 22 (manager, qui livre les alertes) et la ligne 79 (dashboard,
qui interroge l'indexer). Changer un seul des trois ne provoque pas d'erreur explicite, mais une panne
silencieuse : alertes qui cessent d'arriver, dashboard qui refuse la connexion.

La procédure correcte, dans l'ordre :

```bash
export HISTCONTROL=ignorespace       # un espace en tête de ligne la retire de l'historique
docker compose exec -u 0 wazuh.indexer bash \
  /usr/share/wazuh-indexer/plugins/opensearch-security/tools/wazuh-passwords-tool.sh -u admin -p '<NOUVEAU>'
# attendre le message de succès AVANT de continuer
nano single-node/docker-compose.yml  # lignes 22 et 79
docker compose up -d
```

L'outil exige d'être lancé en **root dans le conteneur** (`-u 0`), sinon il répond
`This script must be run as root.` et ne change rien.

## 7. Incidents rencontrés et résolutions

### a. Une release candidate récupérée sans le vouloir

Le clone par défaut du dépôt `wazuh-docker` pointe sur la branche `main`, qui contenait alors
**5.0.0-rc2**. La stack démarrait correctement — trois conteneurs `healthy` — mais **toute
l'arborescence 4.x avait disparu** :

```
ls /var/ossec/bin/            → No such file or directory
ls /var/ossec/logs/alerts/    → No such file or directory
```

Aucune commande du cours (`agent_control`, `alerts.json`) n'était donc utilisable. **Résolution :**
épingler la dernière version stable, `v4.14.10` (les tags `v4.14.11-rc1` et `-rc2` sont des
pré-versions, écartées). Une release candidate n'a pas sa place dans un rendu : on ne peut pas la
reproduire dans trois semaines.

### b. `find: command not found` pendant la génération des certificats

Le conteneur `wazuh-certs-generator:0.0.5` affiche cette erreur (son image ne contient pas `find`).
**Elle est sans conséquence** : les neuf fichiers sont bien écrits dans
`config/wazuh_indexer_ssl_certs/` (`admin.pem`, `root-ca.pem`, `wazuh.indexer.pem`…). Le chemin réel
en 4.14.10 est `config/wazuh_indexer_ssl_certs/`, **et non `config/certs`**.

### c. Un agent resté de l'essai précédent

L'hôte portait encore l'agent **5.0.0-1** de l'essai en release candidate. Il tentait de s'enrôler
toutes les 60 secondes et échouait :

```
ERROR: Enrollment request could not be sent: (7) Could not connect to server:
Failed to connect to 192.168.0.126 port 1517
```

La cause est vérifiable dans les ports publiés : le manager **5.0.0-rc2** exposait `1517`, le manager
**4.14.10** ne l'expose pas. En 4.14, l'enrôlement se fait sur **1515**. **Résolution :** purge du
paquet (`apt-get purge wazuh-agent`, suppression de `/var/ossec`), puis installation du paquet
4.14.10. Le journal de l'échec a été conservé comme preuve.

### d. Un mot de passe changé à moitié — et annulé

Une première tentative a modifié le compose **sans** que le changement ait réussi côté indexer (l'outil
avait refusé de tourner, faute de droits root). Résultat : dashboard et manager envoyaient un mot de
passe que l'indexer ne connaissait pas, donc connexion refusée. **Résolution :** restauration du
compose depuis la sauvegarde (`/tmp/dc.bak`) et `docker compose up -d`. Le mot de passe par défaut est
donc toujours en place — voir §6.

### e. Erreur trompeuse de `wget`

`wget` a rapporté `200 OK` puis `Cannot write to … (No such file or directory)`. La cause n'était pas
le réseau mais le **répertoire courant du terminal, supprimé entre-temps**. Leçon retenue : toujours
`cd` explicitement avant un `docker compose`.

## 8. Preuves

| Capture | Ce qu'elle établit |
|---|---|
| `../screenshots/wazuh-01.png` | l'hôte satisfait les prérequis, versions datées |
| `../screenshots/wazuh-02.png` | les trois services 4.14.10 tournent simultanément |
| `../screenshots/wazuh-03.png` | le dashboard répond en HTTPS, session ouverte |
| `../screenshots/wazuh-04.png` | l'agent `cible-ssh-01` est enrôlé et `active` |
| `../screenshots/wazuh-05.png` | identité de l'agent : enregistré à 13:10:19, keep-alive à 13:15:38 |
| `../screenshots/wazuh-06.png` | 64 événements horodatés, règles `5710`, `5503`, `2502` |
| `../screenshots/wazuh-05b-vulnerabilites.png` | *complément* : 258 vulnérabilités critiques, 2 018 élevées détectées sur l'agent |
| `../screenshots/wazuh-06b-threat-hunting.png` | *complément* : vue de synthèse Threat Hunting filtrée sur l'agent (53 événements, 3 échecs d'authentification) |

## 9. Limites du laboratoire

1. **Agent et manager sur la même machine** — contrainte de mémoire (5.6 Gi libres). Une vraie
   compromission de la cible n'est donc pas simulée.
2. **Mot de passe par défaut conservé** — voir §6.
3. **Trois ports exposés inutilement** sur le réseau local (`9200`, `55000`, `443`).
4. **Règle `5712` non déclenchée** : elle exige huit tentatives du même utilisateur en moins de deux
   minutes ; les tests ont produit `5710` (niveau 5) et `2502` (niveau 10), pas la règle de force brute.
5. **Scans SCA et FIM vides** au moment des captures : ils n'avaient pas encore tourné.
6. **Un seul agent** : la vue multi-agents du dashboard n'est pas démontrée.

## 10. Message de passage aux deux autres

```
Plateforme prête le 2026-11-23 à 13:15 UTC.
Hôte Wazuh        : 192.168.0.126  (ouzziki-HP-EliteBook)
Dashboard         : https://192.168.0.126
Agent             : cible-ssh-01 (ID 001) — statut active à 13:15:38
Cible des tests   : 192.168.0.126 (même machine, contrainte de RAM)
Journaux collectés: sshd, PAM, sudo (via /var/log/auth.log)
Versions          : manager 4.14.10 / indexer 4.14.10 / dashboard 4.14.10 — tag wazuh-docker v4.14.10
Événements        : 64 sur 24 h ; règles 5710, 5503, 2502 visibles
Mot de passe      : valeur dans le gestionnaire du groupe, non consignée ici
```
