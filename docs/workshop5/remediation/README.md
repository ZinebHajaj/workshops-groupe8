# Workshop 5, volet 2 — Remédiation Trivy et image durcie

Ce dossier est le livrable du volet 2. Chaque chiffre ci-dessous est recalculable par une commande du dépôt (les commandes sont citées à côté du chiffre). Scan de référence : 2026-11-01T15:47:26Z, Trivy 0.75.0 — re-scan : 2026-11-04, même version de Trivy.

## 1. Objectif du volet

Transformer les **43 alertes HIGH/CRITICAL** du scan de référence en 43 décisions traçables (40 avec version cible écrite, 3 acceptations assumées sans correctif), produire une **image durcie** à partir de l'image amont épinglée par digest, la **re-scanner avec la même version de Trivy**, et livrer le **tableau avant / après** — sur une branche dédiée, sans toucher à `main`, ni au `Dockerfile` de l'application, ni aux livrables des autres membres.



## 2. Point de départ

Image analysée : `bkimminich/juice-shop`, digest `sha256:42843723a7bf4246aa5d63c324978b17ef296ac78434aeddd34c427bfb5853f4` (copié de `trivy-scan/01-digest-image.txt`) — image **distroless** (preuves §5), Debian 13.7, Trivy 0.75.0.

Compteurs de référence (commande : `cat 02-avant-compte.txt`, copie de `trivy-scan/06-compteurs.txt`) : **11 CRITICAL · 32 HIGH · 43 HIGH+CRITICAL** (corrigibles : 40, sans correctif : 3), 60 MEDIUM, 11 LOW, 1 UNKNOWN, 115 total, 5 secrets (3 HIGH + 2 MEDIUM), 42 findings de configuration H/C.

## 3. Méthode

Trois filtres, dans cet ordre : (1) un correctif existe-t-il ? (2) le paquet est-il dans l'image au runtime ? — réponse tracée dans l'inventaire après — (3) la fonction vulnérable est-elle atteignable depuis un chemin exposé ? Quand le filtre (3) ne peut pas être prouvé, la cellule le dit explicitement : **non vérifié**.

Trois décisions autorisées, aucune autre : `corrigé` (fermé et démontré par le re-scan), `corrigé, adaptation à prévoir` (correctif disponible, version majeure), `accepter et surveiller` (aucun correctif, ou non applicable sans reconstruire l'application, avec mitigation écrite).

## 4. Résultat du tri

- **3 alertes sans correctif** : `CVE-2026-101894` et `CVE-2026-53486` (`decompress` 4.2.1), `GHSA-5mrr-rgp6-x4gr` (`marsdb` 0.6.11) — `cat 00-sans-correctif.tsv`.
- **40 alertes corrigeables** (correctif publié) : toutes portées par des paquets npm de `node_modules` — `grep -cE '^\|\s*[0-9]+' 01-tri-cve.md` renvoie 43, une décision avec preuve par ligne.
- Constat central du re-scan : l'image amont étant déjà à jour côté sécurité de son conteneur d'exécution (distroless, non-root) et les paquets npm n'étant pas modifiables par une couche, **l'écart H+C est nul (43 → 43)**. Un écart nul n'est pas un échec : il est expliqué et documenté (§5 et §7), et la version cible de chaque correctif est écrite dans le tri.
- **8 paquets concentrent le gros des alertes** : `tar` (10 alertes H+C : 1 C + 9 H), `jsonwebtoken` (6, présentes en **deux versions** — 0.1.0 et 0.4.0 — dépendance transitive **non dédupliquée**), `lodash` (3), `minimatch` (3), `undici` (3), `crypto-js` (2 C), `handlebars` (2 C), `moment` (2). Autres alertes isolées : `base64url`, `basic-ftp`, `body-parser`, `decode-uri-component`, `express-jwt`, `http-cache-semantics`, `jws` (×2), `multer`, `sanitize-html`.
- `tar` pèse **10 alertes** alors que les correctifs existent depuis plusieurs versions mineures (`CVE-2026-23745` close par 7.5.3, la plus récente par 7.5.21) : c'est la dette la plus volumineuse et la priorité n°1 de la reconstruction.

## 5. Durcissement — `Dockerfile.durci`

Le durcissement part de l'image **épinglée par digest** (recopié de `trivy-scan/01-digest-image.txt`, 64 caractères, jamais d'ellipse). Il ne redéfinit ni ENTRYPOINT ni CMD (`/nodejs/bin/node` + `/juice-shop/build/app.js`).

**Pourquoi on ne reconstruit pas l'application** : `npm ci` échoue en ERESOLVE, défaut connu du projet depuis le workshop 3 ; patcher l'application est hors sujet du volet et casserait le travail des autres membres. On durcit à la couche ce qui est durcissable et on documente la limite.

**Écart documenté vs. le gabarit prévu par la mission — l'image est distroless.** Essais réels (commandes citées, sorties dans `preuves/`) :

- `docker run --rm --user node --entrypoint /bin/sh …` → `unable to find user node: no matching entries in passwd file` puis `exec: "/bin/sh": no such file or directory` ;
- `docker build` du gabarit `RUN apt-get …` → `exec: "/bin/sh": no such file or directory`, exit 1 (`preuves/essai-gabarit-apt-echec.txt`) ;
- `docker image inspect …@sha256:4284…` → `USER=65532`, `ENTRYPOINT=["/nodejs/bin/node"]`, pas de SHELL.

Conséquences assumées et écrites dans le fichier :

- **DS-0002 (non-root)** : l'amont tourne déjà en `65532` (non-root, distroless). Le durci le **décrit explicitement** par `USER 65532:65534` pour ne plus dépendre des métadonnées amont. Le paquet utilisateur `node` n'existe pas dans cette image ; le plan B `useradd` de la mission est lui aussi inapplicable (pas de shell ni de `useradd`).
- **DS-0025 (cache de paquets)** : non applicable car aucun `/var/lib/apt/lists/*` ni `/var/cache/apt/*` n'existe dans un conteneur distroless. Les vérifications 6 et 7 de la série de la mission attendent littéralement `USER node/app/10001` et une ligne `rm -rf /var/lib/apt/lists` : la première est respectée en esprit (non-root, `65532`, jamais `root`), la seconde est **impossible à satisfaire honnêtement** et est signalée comme telle dans le journal, puisqu'on refuse d'écrire une commande qui n'a jamais tourné.
- **Montée de version des paquets système Debian** : impossible par couche (pas d'APT dans l'image). Le re-scan le montre : les paquets gcc (`gcc-14-base`, `libgcc-s1`, `libgomp1`, `libstdc++6`) restent en `14.2.0-19` — le seul chemin est une **image amont ré-éditée**, hors périmètre.
- **++ ajouté `HEALTHCHECK`** sur `/rest/admin/application-version` (endpoint existant de Juice Shop), en forme exec (`/nodejs/bin/node`).

## 6. Tableau avant / après

Voir `avant-apres.md` (chaque cellule « Après » est copiée depuis un fichier de ce dossier). Résumé :

| Indicateur | Avant | Après |
|---|---|---|
| H+C (périmètre remédiation) | 43 | **43** (écart 0, expliqué) |
| Total sévérités confondues | 115 | 124 (+9 MEDIUM — DB rafraîchie, détaillé dans le tableau) |
| Secrets | 5 | 5 |
| Configuration H/C (Dockerfile) | 2 (`DS-0002`, `DS-0025`) | **0** |
| Configuration H/C (Terraform AWS) | 40 | non re-scanné (hors périmètre, cf. §7) |
| Digest | `sha256:42843723…` | `sha256:075defee5bb4e624c534ef55811f2d1c4d2bc777fb6fae6d56f506141e76c059` |

La hausse de +9 MEDIUM est **due à la base de vulnérabilités rafraîchie entre les deux scans** (2026-11-01 → 2026-11-04) : 3 nouveaux CVE MEDIUM sur 4 paquets gcc (+12) et 3 anciens MEDIUM retirés de la base pour les mêmes versions (`CVE-2026-118764` ×2 minimatch, `CVE-2026-2950` lodash) (−3). **Le re-scan n'a pas été rejoué pour « arranger » les chiffres** ; les deux dates sont citées et les listes de diff sont dans le journal.

## 7. Limites

- Les 43 alertes H+C restent présentes après le durcissement : elles vivent dans `node_modules`, inaccessibles sans reconstruire l'application (`npm ci` ERESOLVE). La décision écrite pour les 40 avec correctif est `accepter et surveiller` + version cible (mémoire de remédiation), pas une fermeture.
- Le filtre (3) (atteignabilité du chemin vulnérable) n'est prouvé pour aucune alerte : toutes les lignes du tri portent la mention **non vérifié** — à confirmer par un test applicatif.
- Le montant de montée de version des paquets système est hors d'atteinte du volet ; il exige une image amont nouvelle (autre digest, donc autre comparabilité).
- Les 40 findings Terraform AWS de la référence ne sont pas re-scannés : le durcissement ne les touche pas (phrase reprise dans `avant-apres.md`).
- Les secrets (5) restent : ils appartiennent à l'application elle-même (fichiers de tests, `lib/insecurity.ts`, `infrastructure/terraform/cert/…`) — on cite les chemins, jamais les valeurs.
- Un seul essai du gabarit `apt-get` a été fait (pas de re-essai pour « plaire au chiffre ») : la preuve de l'infaisabilité est dans `preuves/essai-gabarit-apt-echec.txt`.

## 8. Reproduire

```bash
trivy --version                                   # 0.75.0
awk -F'\t' '$1=="CRITICAL"||$1=="HIGH"' docs/workshop5/remediation/02-avant.tsv | wc -l   # 43
docker build --no-cache -f docs/workshop5/remediation/Dockerfile.durci -t juice-shop-durci:workshop5 docs/workshop5
trivy image -f table juice-shop-durci:workshop5   # à comparer à 04-apres.txt
```
