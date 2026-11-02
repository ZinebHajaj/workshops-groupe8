# Scan Trivy — image de référence (volet Lhoussaine)

## Identité de la cible et de l'outil

| Élément | Valeur |
|---|---|
| Image scannée | `bkimminich/juice-shop:latest` |
| Digest | `sha256:42843723a7bf4246aa5d63c324978b17ef296ac78434aeddd34c427bfb5853f4` |
| Scanner | Trivy **0.75.0** (`aquasec/trivy:latest`) — 0.76.1 disponible au moment du run |
| Date du run | `2026-11-01T15:47:26Z` (UTC) |
| Cibles analysées | **7** blocs `Results` dans le rapport JSON |
| Formats produits | table, JSON, SARIF, SBOM CycloneDX |

> Le digest est **identique** à celui relevé au workshop 4 (`docs/workshop4/zap-passif/image-digest.txt`) :
> la même image a donc été attaquée en fonctionnement par ZAP, puis analysée au repos par Trivy.

## Commandes exécutées

```bash
docker run --rm aquasec/trivy:latest --version
docker images --digests bkimminich/juice-shop

docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy:latest image --severity HIGH,CRITICAL --scanners vuln \
  bkimminich/juice-shop:latest

docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$PWD:/out" aquasec/trivy:latest image --format json \
  --output /out/03-rapport.json bkimminich/juice-shop:latest

docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$PWD:/out" aquasec/trivy:latest image --format cyclonedx \
  --output /out/03-sbom.cdx.json bkimminich/juice-shop:latest

docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy:latest image --scanners secret \
  bkimminich/juice-shop:latest

docker run --rm -v "$PWD:/src" aquasec/trivy:latest config --severity HIGH,CRITICAL /src
```

## Résultat du scan de vulnérabilités

| Sévérité | Nombre |
|---|---|
| CRITICAL | **11** |
| HIGH | **32** |
| MEDIUM | 60 |
| LOW | 11 |
| UNKNOWN | 1 |
| **Total, toutes sévérités** | **115** |
| **HIGH + CRITICAL** | **43** |

Parmi les **43** alertes HIGH et CRITICAL :

| Indicateur | Valeur |
|---|---|
| avec une version corrigée disponible | **40** |
| sans version corrigée | **3** |
| paquets les plus touchés | `libc6` 22 · `tar` 12 · `sanitize-html` 11 · `jsonwebtoken` 10 · `minimatch` 6 |

Ces chiffres sont recalculés depuis le JSON, jamais saisis à la main :

```bash
cut -f1 06-inventaire.tsv | sort | uniq -c | sort -rn
awk -F'\t' '$1=="CRITICAL"||$1=="HIGH"' 06-inventaire.tsv | wc -l
awk -F'\t' '($1=="CRITICAL"||$1=="HIGH") && $5!="" && $5!="-" && $5!="NA"' 06-inventaire.tsv | wc -l
```

> Formulation correcte dans le rapport : « **43 vulnérabilités HIGH et CRITICAL** », et non
> « 115 vulnérabilités » — 115 est le total toutes sévérités, MEDIUM et UNKNOWN inclus.

## Extrait des alertes (15 premières lignes HIGH / CRITICAL)

| Sévérité | Identifiant | Paquet | Version installée | Version corrigée |
|---|---|---|---|---|
| CRITICAL | CVE-2023-46233 | crypto-js | 3.3.0 | 4.2.0 |
| CRITICAL | CVE-2026-71851 | crypto-js | 3.3.0 | 4.0.0 |
| CRITICAL | CVE-2026-101894 | decompress | 4.2.1 | — |
| CRITICAL | CVE-2026-53486 | decompress | 4.2.1 | — |
| CRITICAL | CVE-2026-106445 | handlebars | 4.7.9 | 4.7.10 |
| CRITICAL | CVE-2026-106446 | handlebars | 4.7.9 | 4.7.10 |
| CRITICAL | CVE-2015-9235 | jsonwebtoken | 0.1.0 | 4.2.2 |
| HIGH | NSWG-ECO-428 | base64url | 0.0.6 | >=3.0.0 |
| HIGH | CVE-2026-102990 | basic-ftp | 5.3.1 | 6.2.1 |
| HIGH | CVE-2026-111181 | body-parser | 1.20.8 | 2.4.0, 1.20.9 |
| HIGH | CVE-2026-118664 | decode-uri-component | 0.2.2 | 0.5.1 |
| HIGH | CVE-2020-15084 | express-jwt | 0.1.3 | 6.0.0 |
| HIGH | CVE-2022-25881 | http-cache-semantics | 3.8.1 | 4.1.1 |
| HIGH | CVE-2022-23539 | jsonwebtoken | 0.1.0 | 9.0.0 |
| HIGH | NSWG-ECO-17 | jsonwebtoken | 0.1.0 | >=4.2.2 |

La liste complète des 115 lignes est dans `06-inventaire.tsv` (calculée depuis `03-rapport.json`).

### Ce que l'extrait montre déjà

- **`jsonwebtoken 0.1.0`** : version très ancienne de la bibliothèque qui signe les jetons d'authentification.
  Deux CVE HIGH et une CRITICAL la visent, avec correctifs disponibles (4.2.2 puis 9.0.0) : c'est le
  premier candidat de remédiation pour Hasna.
- **`crypto-js 3.3.0`** : deux CVE CRITICAL avec correctifs (4.0.0 et 4.2.0). Même conclusion.
- **`decompress 4.2.1`** : deux CVE CRITICAL **sans version corrigée** (`—`). Aucune mise à jour ne les fermera :
  cas à documenter en « accepter et surveiller », pas à corriger.
- **`express-jwt 0.1.3`**, **`base64url 0.0.6`**, **`body-parser 1.20.8`** : versions d'une autre époque,
  toutes corrigeables.

## Secrets — 1 secret détecté (HIGH)

| Élément | Valeur |
|---|---|
| Règle | `AsymmetricPrivateKey` (type `private-key`) |
| Sévérité | HIGH |
| Fichier | `/juice-shop/lib/insecurity.ts:21` |
| Couche d'origine | `COPY --chown=65532:0 /juice-shop .` (étape de build) |

Le reste de l'image est propre : Trivy annonce `Total: 1` et les manifestes `package.json` scannés ne
contiennent aucun secret.

**Ce que c'est :** Juice Shop embarque dans son code une **clé privée RSA** qui signe les jetons JWT — le module
s'appelle d'ailleurs `insecurity.ts`, c'est un choix pédagogique assumé de l'application. La conséquence, dans une
vraie application, serait directe : toute personne qui télécharge l'image peut forger des jetons valides.

**Décision :** aucune correction de notre part. L'image est publiée telle quelle par son éditeur et nous ne modifions
pas le code de l'application. Le constat est documenté comme risque de conception.

> Aucune valeur de clé n'est recopiée dans ce document, ni dans le README du workshop : on cite le chemin, la règle
> et la décision.

## Mauvaises configurations — 42 alertes, dont **0** dans le Dockerfile de l'application

Scan `trivy config` sur le répertoire du dépôt : **13 fichiers de configuration détectés**.

| Cible | Type | Mauvaises configurations |
|---|---|---|
| `Dockerfile` (racine) | dockerfile | **0** |
| `infrastructure/Dockerfile` | dockerfile | **0** |
| `test/smoke/Dockerfile` | dockerfile | 2 (HIGH ×2) |
| `data/static/codefixes/iacLeakedKeyChallenge_1.tf` | terraform | 8 (4 HIGH, 4 CRITICAL) |
| `data/static/codefixes/iacLeakedKeyChallenge_2.tf` | terraform | 8 (4 HIGH, 4 CRITICAL) |
| `data/static/codefixes/iacLeakedKeyChallenge_3_correct.tf` | terraform | 8 (4 HIGH, 4 CRITICAL) |
| `infrastructure/terraform/networking.tf` | terraform | 8 (4 HIGH, 4 CRITICAL) |
| `terraform/networking.tf` | terraform | 8 (4 HIGH, 4 CRITICAL) |
| `terraform/main.tf`, `infrastructure/terraform/main.tf`, dossiers `.tf` | terraform | **0** |
| **Total** | | **42** (22 HIGH, 20 CRITICAL) |

Règles rencontrées :

| Règle | Sévérité | Constat |
|---|---|---|
| `DS-0002` | HIGH | aucun `USER` non-root dans `test/smoke/Dockerfile` |
| `DS-0025` | HIGH | `apk add curl` sans `--no-cache` (cache conservé dans l'image) |
| `AWS-0037` | HIGH | système de fichiers EFS non chiffré au repos |
| `AWS-0052` | HIGH | le load balancer ne rejette pas les en-têtes invalides |
| `AWS-0053` | HIGH | load balancer exposé publiquement |
| `AWS-0054` | CRITICAL | écouteur HTTP sans HTTPS |
| `AWS-0104` | CRITICAL | règles de sortie ouvertes vers `0.0.0.0/0` |
| `AWS-0164` | HIGH | sous-réseau qui attribue une IP publique |

**Lecture critique, à écrire telle quelle dans le rapport :** ces 42 alertes **ne concernent pas l'image livrée**.
- Les cinq fichiers `.tf` en cause appartiennent à Juice Shop : trois sont des **fixtures pédagogiques**
  (`data/static/codefixes/…`, volontairement vulnérables), deux décrivent une infrastructure AWS d'exemple
  (`terraform/`, `infrastructure/terraform/`) que nous n'utilisons pas.
- Le `Dockerfile` de l'application est **propre** au regard de `trivy config` — les deux seules alertes Dockerfile
  sont dans un fichier de test de fumée.

Autrement dit : le scan ne dit pas « notre image est mal configurée », il dit « le dépôt contient des exemples
d'infrastructure non conformes ». C'est exactement le genre de nuance qu'un correcteur attend.

## Limites de ce scan

- Le scan est **non authentifié** et porte sur l'image : aucune logique métier, aucune route dynamique.
- L'image est analysée **au repos** : les vulnérabilités d'exécution relèvent du workshop 4 (ZAP).
- Les CVE `UNKNOWN` (1) n'ont pas de score attribué : comptées à part, pas rangées de force.
- La base de vulnérabilités et les règles évoluent : ces chiffres valent **au 2026-11-01**, avec Trivy 0.75.0.
- Un secret détecté dans une image publique de démonstration est un **choix de conception** de l'éditeur, pas une
  erreur de notre pipeline — mais il illustre pourquoi un secret ne doit jamais être copié dans une image.

## Preuves produites

| Fichier | Contenu |
|---|---|
| `00-version-trivy.txt` | version de Trivy, date UTC, état du poste |
| `01-digest-image.txt` | digest de l'image scannée |
| `02-vulns-high-critical.txt` | tableau lisible (sortie console) |
| `03-rapport.json` | rapport complet, **non filtré** |
| `03-rapport.sarif` | même contenu, format CI |
| `03-sbom.cdx.json` | SBOM CycloneDX |
| `04-secrets.txt` | rapport du scan de secrets (1 secret, HIGH) |
| `05-misconfig-dockerfile.txt` | rapport de `trivy config` (42 alertes) |
| `06-inventaire.tsv` | une ligne par CVE, extraite du JSON |
| `06-compteurs.txt` | compteurs recalculés depuis le TSV |
| `07-sha256.txt` | empreintes de toutes les preuves |

## Ce que le volet transmet à Hasna

| Élément | Où |
|---|---|
| les 43 alertes HIGH / CRITICAL à trier | `06-inventaire.tsv` |
| les 3 sans version corrigée | filtre `$5=="" || $5=="-"` sur le TSV |
| les 40 corrigeables, dont `jsonwebtoken` et `crypto-js` en tête | tableau ci-dessus |
| l'identité exacte de l'image (digest) pour comparer avant / après | `01-digest-image.txt` |
| l'état de configuration du dépôt, pour son durcissement | `05-misconfig-dockerfile.txt` |
