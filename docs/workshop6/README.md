# Workshop 6 — périmètre du laboratoire

Document validé par les trois membres avant le début des tests.
Ce qui n'est pas écrit ici n'est pas autorisé.

## Machines

| Rôle | Nom | Adresse | Remarque |
|---|---|---|---|
| Hôte Wazuh (stack) | `ouzziki-HP-EliteBook` | `192.168.0.126` | Ubuntu 26.04.1 LTS, 8 vCPU, 14 Gi |
| Cible (agent) | `ouzziki-HP-EliteBook` | `192.168.0.126` | **même machine que l'hôte** : contrainte de RAM (5.6 Gi disponibles au moment du déploiement) |

L'agent et le manager cohabitent donc sur le même hôte. C'est une limite assumée du laboratoire :
en production, l'agent serait sur une machine distincte, ce qui permettrait de tester une vraie
compromission de bout en bout. Le nom d'agent `cible-ssh-01` garde malgré tout la trace de son rôle.

## Plage horaire

Tests réalisés le **2026-11-23**, de **12:00** à **14:00** UTC.

## Actions autorisées

- tentatives de connexion SSH avec un utilisateur inexistant (`ssh faux-user@127.0.0.1`) ;
- tentatives `sudo` avec un mot de passe erroné ;
- un `sudo` réussi, pour produire un événement d'élévation de privilèges ;
- consultation du dashboard et export des captures.

## Actions interdites

- aucun autre service de la machine (pas de test sur les applications du groupe) ;
- aucune machine hors de `192.168.0.0/24` ;
- aucune adresse publique, aucun scan réseau ;
- aucun test de force brute contre un service réel autre que le SSH local ;
- aucun mot de passe écrit dans un fichier, une capture ou l'historique du shell.

## Arborescence des livrables

Tout le workshop 6 est rangé sous `docs/workshop6/`, rien n'est ajouté à la racine du dépôt :

```
docs/workshop6/
├── README.md                 ← ce document (périmètre)
├── plateforme/
│   ├── README.md
│   └── 01-versions.txt
└── screenshots/
    └── wazuh-01.png … wazuh-06.png  (+ 2 compléments)
```

Les captures d'un workshop vivent avec ses documents — comme `docs/workshop3/screenshots/` déjà
présent dans le dépôt.

## Résultat attendu

Des événements horodatés remontant de l'agent `cible-ssh-01` jusqu'au dashboard, rattachés à des
règles identifiables, exploitables par le volet détection (Hasna) et mesurables par le volet réponse
(Zineb).
