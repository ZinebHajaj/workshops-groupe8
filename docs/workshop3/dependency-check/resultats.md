# Résultats OWASP Dependency-Check — Workshop 3

## 1. Informations générales

- **Responsable :** Ouzziki Lhoussaine
- **Branche de travail initiale :** `workshop3-dependency-check-lhoussaine`
- **Branche des corrections ciblées supplémentaires :** `workshop3-critical-remediation-lhoussaine`
- **Branche de rendu :** `Workshop3`
- **Run intégré de vérification :** [Workshop 3 - SCA #14](https://github.com/ZinebHajaj/workshops-groupe8/actions/runs/41216021010)
- **Commit intégré vérifié :** `97ad34325303c83c37498ed38748998056ae95ff`
- **Artifact :** `dependency-check-report`

Ce document distingue deux étapes de remédiation et leurs preuves. Il ne présente pas les rapports comme si leur couverture était identique et ne déclare pas un projet sans vulnérabilité ou un pipeline vert.

## 2. Correction 1 — PDFKit / CryptoJS

### Finding initial

| Élément | Valeur |
|---|---|
| Dépendance vulnérable | `crypto-js@3.3.0` |
| Type | Dépendance transitive |
| Chaîne | `pdfkit@0.11.0 → crypto-js@3.3.0` |
| Identifiants | `GHSA-xwcq-pm8m-c4vf` / `CVE-2023-46233` ; `GHSA-rg76-677x-56q9` / `CVE-2026-71851` |

### Correction et vérifications

- PDFKit : `0.11.0 → 0.20.2`.
- Commit : `a1c15a5`.
- `pdfkit@0.20.2` ne déclare plus `crypto-js` ; CryptoJS est absent du lockfile et de `npm ls`.
- Builds frontend et serveur TypeScript réussis.
- Tests `test/server/order.unit.test.ts` : 10 réussis, 0 échoué.

## 3. Correction 2 — Express-JWT

### Finding initial

| Élément | Valeur |
|---|---|
| Dépendance | `express-jwt@0.1.3` |
| Type | Dépendance directe |
| Identifiant | `GHSA-6g6m-m6h5-w9gf` / `CVE-2020-15084` |
| Version corrigée minimale | `6.0.0` |

### Correction et vérifications

- `express-jwt : 0.1.3 → 6.0.0`.
- Commit : `c60aca3`.
- `isAuthorized` : `algorithms: ['RS256']`.
- `denyAll` : `algorithms: ['HS256']`.
- Suppression des casts `as any` qui masquaient les options obligatoires.
- Builds frontend et serveur réussis.
- Tests `insecurity.unit.test.ts` : 54 réussis, 0 échoué.

Les dépendances `jsonwebtoken` directes et transitives restent analysées séparément.

## 4. Comparaison locale initiale avant / après

### Environnement et limites

- Image : `owasp/dependency-check:latest`.
- Digest consigné : `sha256:0e8f69ad5b00d62000937f4e57189812343f6903d9c83ee712012d51542a020a`.
- Portée : manifests et lockfiles racine et frontend.
- Options de reprise : `--noupdate`, `--network host` et `--disableNodeAuditCache`.
- Journaux : `reports/after-scan-cached.log` et `reports/after-verbose.log`.

La mise à jour NVD ayant échoué à plusieurs reprises, le scan local après utilise la base NVD existante avec `--noupdate`. Le Node Audit Analyzer a terminé et le rapport a été généré. Cette limitation n'est pas présentée comme une mise à jour NVD réussie.

### Résultats ciblés

| Dépendance avant | Advisory | Correction | Après |
|---|---|---|---|
| `crypto-js@3.3.0` via PDFKit | `GHSA-xwcq-pm8m-c4vf` | PDFKit `0.20.2` | Absente |
| `crypto-js@3.3.0` via PDFKit | `GHSA-rg76-677x-56q9` | PDFKit `0.20.2` | Absente |
| `express-jwt@0.1.3` | `GHSA-6g6m-m6h5-w9gf` | Express-JWT `6.0.0` | Absente |

Les trois lignes sont présentes dans `reports/before/findings.tsv` et absentes de `reports/after/findings.tsv`. Un `npm audit --package-lock-only --json` indépendant confirme aussi l'absence des trois advisories.

### Lecture des totaux

| Extraction | NPM | NVD | Total |
|---|---:|---:|---:|
| Avant | 46 | 0 | 46 |
| Après | 45 | 23 | 68 |

La comparaison normalisée par `package:version + advisory/CVE` donne trois couples ciblés supprimés et 25 couples supplémentaires. La couverture change entre les deux extractions : les lignes supplémentaires restent à trier et ne prouvent pas que les commits ont introduit de nouvelles vulnérabilités.

Preuves conservées :

- `reports/targeted-comparison.txt`
- `reports/npm-audit-after-root.json`
- `reports/findings-before-after.diff`
- `reports/findings-normalized-delta.txt`
- `reports/findings-added-normalized.tsv`
- `reports/findings-removed-normalized.tsv`
- `reports/report-sha256.txt`

## 5. Corrections ciblées supplémentaires

| Correction | Décision | Code | Documentation |
|---|---|---|---|
| CycloneDX | `@cyclonedx/cyclonedx-npm : 4.2.1 → 6.0.0` | `c099896` | `2ba3ab1` |
| Basic-FTP | Override exact `basic-ftp=6.2.1` dans le manifeste racine | `84e0890` | `bd04da0` |
| decode-uri-component | Override de `normalize-url` vers `3.3.0`, limité à `cacheable-request@2.1.4` | `ab8c121` | `5387f88` |

### CycloneDX

Les deux advisories ciblées sont `GHSA-q69g-4hcv-6jg4` et `GHSA-v75r-vx73-82pj`. Les builds et la génération SBOM ont été validés. Les notes détaillées sont dans `docs/workshop3/critical-remediation/cyclonedx.md`.

### Basic-FTP

La chaîne réelle était :

`proxy-agent@8.0.2 → pac-proxy-agent@9.1.0 → get-uri@8.0.1 → basic-ftp@5.3.1`

L'override installe `basic-ftp@6.2.1`. L'import de `get-uri`, les 55 tests utils, le test de téléchargement via proxy HTTPS et les builds ont réussi. `GHSA-c475-qrg2-pj4r` est absente du nouvel npm audit, dont les autres findings restent conservés. Voir `docs/workshop3/critical-remediation/basic-ftp.md`.

### decode-uri-component

La chaîne initiale était :

`download@8.0.0 → got@8.3.2 → cacheable-request@2.1.4 → normalize-url@2.0.1 → query-string@5.1.1 → decode-uri-component@0.2.2`

Un override direct vers `decode-uri-component@0.5.1` a été écarté : `query-string@5.1.1` utilise CommonJS et appelle directement la valeur importée, alors que `0.5.1` est ESM-only avec un export par défaut.

Avec l'override du parent, la chaîne se termine par `normalize-url@3.3.0 overridden`. Cinq entrées de lockfile changent : `normalize-url` est mise à jour et `decode-uri-component`, `query-string`, `sort-keys` et `strict-uri-encode` sont supprimées.

Validations :

- téléchargement HTTP local réel et réutilisation du cache ;
- 55/55 tests utils, sans échec ni skip ;
- builds serveur et frontend, plus SBOM frontend ;
- `GHSA-qr28-fpjm-wq7f` et `GHSA-vcc3-ghjq-m6fr` absentes du nouvel npm audit ;
- npm audit toujours en échec à cause de findings sans rapport, sans affirmation de statut propre.

Voir `docs/workshop3/critical-remediation/decode-uri-component.md` et `reports/critical-remediation/`.

## 6. Vérification intégrée finale — run #14

### Exécution

| Élément | Résultat |
|---|---|
| Branche | `Workshop3` |
| Commit | `97ad343` |
| Build | Réussi |
| Analyse Dependency-Check | `Analysis Complete` |
| Rapport HTML | Généré à 2026-10-31 15:48:55 GMT |
| Artifact | Publié |
| Security gate | Échec, code 15, car des findings CVSS ≥ 9 subsistent |
| Suppressions | 0 |

L'artifact publié ne signifie pas que le gate a réussi.

### Rapports comparés

| Élément | Rapport CI de référence | Rapport du run #14 |
|---|---|---|
| Version Dependency-Check | 13.0.0 | 13.0.0 |
| Génération | 2026-10-31 13:27:17 GMT | 2026-10-31 15:48:55 GMT |
| Dépendances analysées | 21 | 18 |
| Dépendances vulnérables | 21 | 18 |
| Findings | 47 | 42 |
| Suppressions | 0 | 0 |

Le HTML de référence ne contient pas de SHA de commit : aucun run ne lui est attribué arbitrairement. Les dates de dernière modification NVD diffèrent également. La comparaison est donc normalisée par dépendance et advisory et reste limitée à la couverture de ces scans CI.

### Résultat normalisé ciblé

| Dépendance de la référence | Advisories ciblées | Rapport du run #14 |
|---|---|---|
| `@cyclonedx/cyclonedx-npm:4.2.1` | `GHSA-q69g-4hcv-6jg4`, `GHSA-v75r-vx73-82pj` | Entrée et advisories absentes |
| `basic-ftp:5.3.1` | `GHSA-c475-qrg2-pj4r` | Entrée et advisory absentes |
| `decode-uri-component:0.2.2` | `GHSA-qr28-fpjm-wq7f`, `GHSA-vcc3-ghjq-m6fr` | Entrée et advisories absentes |

- Sections supprimées : exactement les trois sections ciblées.
- Findings ciblés absents : cinq.
- Nouvelles sections de dépendances : aucune.
- Changements dans les ensembles d'advisories des 18 dépendances partagées restantes : aucun.
- Suppressions introduites : aucune.

Ces résultats vérifient les cinq findings ciblés dans le périmètre du rapport CI. Ils ne constituent pas une déclaration de réduction globale du risque.

## 7. Findings restants au gate

| Dépendance | Advisories affichées dans le log du run #14 |
|---|---|
| `decompress@4.2.1` | `GHSA-hrh2-vp3x-79xf`, `GHSA-mp2f-45pm-3cg9` |
| `jsonwebtoken@0.4.0` | `GHSA-c7hr-j4mj-j2w6` |
| `lodash@2.4.2` | `GHSA-4xc9-xhrj-v574`, `GHSA-jf85-cpcp-j695` |
| `marsdb@0.6.11` | `GHSA-5mrr-rgp6-x4gr` |
| `minimatch@3.0.5` | `GHSA-3ppc-4f35-3m26` |

Ces composants ne sont pas déclarés corrigés. Le rapport du run #14 contient encore 42 findings. Toute remédiation ultérieure doit rester une décision séparée avec preuve de compatibilité.

## 8. Captures et preuves CI

| Capture | Légende |
|---|---|
| [01 — Résumé avant](../screenshots/dependency-check-01-avant-resume.png) | Rapport initial avec les informations du scan. |
| [02 — Détail avant](../screenshots/dependency-check-02-avant-detail.png) | Finding ciblé avant remédiation. |
| [03 — Diff des corrections](../screenshots/dependency-check-03-diff-correction.png) | PDFKit, Express-JWT et algorithmes RS256/HS256. |
| [04 — Résumé après](../screenshots/dependency-check-04-apres-resume.png) | Rapport local après avec limites documentées. |
| [05 — Comparaison ciblée](../screenshots/dependency-check-05-apres-detail.png) | Trois findings initiaux présents avant et absents après. |
| [06 — Run intégré #14](../screenshots/dependency-check-06-build.png) | Build vert, Dependency-Check rouge au gate et un artifact, sur le run de Lhoussaine. |
| [07 — Versions après](../screenshots/dependency-check-07-versions-apres.png) | PDFKit et Express-JWT corrigés, absence de CryptoJS dans l'arbre affiché. |

Les preuves finales comprennent également le run #14, son journal, son artifact HTML et les comparaisons normalisées. Aucun run d'un autre membre n'est présenté comme le run intégré de Lhoussaine.

## 9. Statut final

Les corrections ciblées sont validées par des preuves locales et par le run intégré #14 selon leurs périmètres respectifs. Le build est vert, le rapport est disponible et le gate Dependency-Check reste rouge pour les findings restants. Le seuil `--failOnCVSS 9` n'a pas été affaibli et aucune suppression générale ou option `continue-on-error` n'a été ajoutée.
