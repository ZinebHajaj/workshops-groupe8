# Scan Trivy — image de référence (volet Lhoussaine)

## Identité de la cible et de l'outil

| Élément | Valeur |
|---|---|
| Image scannée | `bkimminich/juice-shop:latest` |
| Digest | `sha256:42843723a7bf4246aa5d63c324978b17ef296ac78434aeddd34c427bfb5853f4` |
| Scanner | Trivy **0.75.0** (`aquasec/trivy:latest`) |
| Date du run | `2026-11-01T15:47:26Z` (UTC) |
| Cibles analysées | **7** blocs `Results` dans le rapport JSON |
| Format | table + JSON + SARIF + SBOM CycloneDX |

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

docker run --rm -v "$PWD:/src" aquasec/trivy:latest config /src
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
| paquets distincts concernés | 22 `libc6`, 12 `tar`, 11 `sanitize-html`, 10 `jsonwebtoken`, 6 `minimatch` (top 5) |

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
  Deux CVE HIGH et une CRITICAL la visent, avec des correctifs disponibles (4.2.2 puis 9.0.0) : c'est le
  premier candidat de remédiation pour Hasna.
- **`crypto-js 3.3.0`** : deux CVE CRITICAL avec correctifs (4.0.0 et 4.2.0). Même conclusion.
- **`decompress 4.2.1`** : deux CVE CRITICAL **sans version corrigée** (`—`). Aucune mise à jour ne les fermera :
  ce sont des cas à documenter en « accepter et surveiller », pas à corriger.
- **`express-jwt 0.1.3`**, **`base64url 0.0.6`**, **`body-parser 1.20.8`** : versions d'une autre époque,
  toutes corrigeables.

## Secrets

Le fichier `04-secrets.txt` contient la sortie complète du journal (`2>&1`) : son nombre de lignes ne mesure
pas les secrets trouvés. Le compte réel est obtenu par un scan propre :

```bash
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy:latest image --scanners secret --quiet \
  bkimminich/juice-shop:latest
```

> À compléter avec le résultat de ce scan propre. Aucun secret n'est recopié dans ce document : on ne cite que
> le chemin, le type et la décision.

## Mauvaises configurations

Résultat de `trivy config` sur le répertoire du dépôt : voir `05-misconfig-dockerfile.txt`.
Cette partie est reprise et traitée par Hasna (durcissement du Dockerfile).

## Limites de ce scan

- Le scan est **non authentifié** et ne porte que sur l'image : aucune logique métier, aucune route dynamique.
- L'image est scannée **au repos** : les vulnérabilités d'exécution relèvent du workshop 4 (ZAP).
- Les CVE `UNKNOWN` (1) n'ont pas de score attribué : elles sont comptées à part, pas rangées de force.
- La base de vulnérabilités évolue : ces chiffres sont valables **au 2026-11-01**, à la version de Trivy 0.75.0.

## Preuves produites

| Fichier | Contenu |
|---|---|
| `00-version-trivy.txt` | version de Trivy, date UTC, état du poste |
| `01-digest-image.txt` | digest de l'image scannée |
| `02-vulns-high-critical.txt` | tableau lisible (sortie console) |
| `03-rapport.json` | rapport complet, **non filtré** |
| `03-rapport.sarif` | même contenu, format CI |
| `03-sbom.cdx.json` | SBOM CycloneDX |
| `04-secrets.txt` | journal du scan de secrets |
| `05-misconfig-dockerfile.txt` | résultat de `trivy config` |
| `06-inventaire.tsv` | une ligne par CVE, extraite du JSON |
| `06-compteurs.txt` | compteurs recalculés |
| `07-sha256.txt` | empreintes de toutes les preuves |
