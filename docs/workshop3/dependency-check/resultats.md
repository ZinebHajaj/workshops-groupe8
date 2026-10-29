# Résultats OWASP Dependency-Check — Workshop 3

## Informations générales

- Responsable : Ouzziki Lhoussaine
- Branche : workshop3-dependency-check-lhoussaine
- Rapport avant : reports/before/dependency-check-report.html
- Rapport après : à réaliser après les corrections
- Extraction avant : 46 lignes de findings + 1 ligne d’en-tête

## Correction 1 — PDFKit / CryptoJS

### Finding initial

| Élément | Valeur |
|---|---|
| Dépendance vulnérable | crypto-js@3.3.0 |
| Type | Dépendance transitive |
| Chaîne avant correction | pdfkit@0.11.0 → crypto-js@3.3.0 |
| Identifiants | GHSA-xwcq-pm8m-c4vf / CVE-2023-46233 ; GHSA-rg76-677x-56q9 / CVE-2026-71851 |
| Sévérité dans le rapport | Critical |

### Correction choisie

| Élément | Avant | Après |
|---|---|---|
| PDFKit | 0.11.0 | 0.20.2 |
| CryptoJS | 3.3.0 via PDFKit | Absent du lockfile et de npm ls |

**Justification :** pdfkit@0.20.2 ne déclare plus crypto-js.
Il utilise notamment @noble/hashes et @noble/ciphers.
La mise à jour du parent supprime donc la dépendance vulnérable
sans ajouter crypto-js comme dépendance directe.

**Commit :** a1c15a5 — fix(deps): update pdfkit to 0.20.2

### Vérifications techniques

| Vérification | Résultat |
|---|---|
| Version PDFKit dans package-lock.json | 0.20.2 |
| CryptoJS dans package-lock.json | Absent |
| npm ls pdfkit crypto-js | Seulement pdfkit@0.20.2 |
| Build frontend | Réussi |
| Build serveur TypeScript | Réussi |
| Tests test/server/order.unit.test.ts | 10 réussis, 0 échoué |

### Statut final SCA

Correction technique validée.
La résolution des findings doit encore être confirmée par le scan
OWASP Dependency-Check « après ».

## Comparaison finale avant / après

À compléter après le scan final avec les mêmes paramètres que le scan initial.

## Correction 2 — express-jwt

### Finding initial

| Élément | Valeur |
|---|---|
| Dépendance | express-jwt@0.1.3 |
| Type | Dépendance directe |
| Identifiants | GHSA-6g6m-m6h5-w9gf / CVE-2020-15084 |
| Sévérité / score | High / 7.7 |
| Version corrigée minimale | 6.0.0 |

### Correction appliquée

- express-jwt : 0.1.3 → 6.0.0
- isAuthorized : ajout de algorithms: ['RS256']
- denyAll : ajout de algorithms: ['HS256']
- Suppression des casts as any masquant les options obligatoires
- Commit : c60aca3

### Vérifications

| Vérification | Résultat |
|---|---|
| npm ls express-jwt | express-jwt@6.0.0 |
| Build serveur TypeScript | Réussi |
| Build frontend | Réussi |
| Tests insecurity.unit.test.ts | 54 réussis, 0 échoué |

Les dépendances jsonwebtoken directes et transitives restent à analyser
séparément. La disparition du finding express-jwt doit être confirmée
par le scan Dependency-Check « après ».

<!-- workshop3-final-after-scan -->
## Comparaison finale avant/après — 2026-10-29

### Scan après retenu et limites

- Image : `owasp/dependency-check:latest`
- Digest : `sha256:0e8f69ad5b00d62000937f4e57189812343f6903d9c83ee712012d51542a020a`
- Portée : les manifests et lockfiles racine et frontend, comme pour le scan avant.
- Options de reprise : `--noupdate`, `--network host` et `--disableNodeAuditCache`.
- Environnement et horodatage : `reports/after-environment.txt`.
- Journaux : `reports/after-scan-cached.log` et `reports/after-verbose.log`.

Le **Node Audit Analyzer a terminé avec succès**. Le journal final ne contient
ni `Node Audit Analyzer ... being disabled`, ni erreur de génération du rapport.

La mise à jour NVD ayant échoué à plusieurs reprises, le scan utilise la base
NVD locale avec `--noupdate`. Les avertissements non fataux
`Unsupported CVSS vector format ''` sont conservés dans les journaux.

### Résultats ciblés

| Dépendance avant | Advisory | Sévérité | Correction | Après |
|---|---|---|---|---|
| `crypto-js@3.3.0` via `pdfkit@0.11.0` | GHSA-xwcq-pm8m-c4vf | Critical 9.1 | PDFKit `0.20.2`, commit `a1c15a5` | Absente |
| `crypto-js@3.3.0` via `pdfkit@0.11.0` | GHSA-rg76-677x-56q9 | Critical 9.0 | PDFKit `0.20.2`, commit `a1c15a5` | Absente |
| `express-jwt@0.1.3` | GHSA-6g6m-m6h5-w9gf | High 7.7 | Express-JWT `6.0.0`, commit `c60aca3` | Absente |

Les trois lignes sont présentes dans `reports/before/findings.tsv` et absentes
de `reports/after/findings.tsv`. La vérification brute est conservée dans
`reports/targeted-comparison.txt`.

Le `npm audit --package-lock-only --json` indépendant confirme aussi l'absence
des trois GHSAs. Sa sortie est conservée dans
`reports/npm-audit-after-root.json`. Les autres findings ne sont pas déclarés
corrigés.

### Lecture correcte des totaux

| Extraction | NPM | NVD | Total |
|---|---:|---:|---:|
| Avant | 46 | 0 | 46 |
| Après | 45 | 23 | 68 |

La comparaison normalisée par `package:version + advisory/CVE` donne :

- **3 couples supprimés**, exactement les trois findings ciblés ;
- **25 couples supplémentaires**, dont 23 NVD et 2 NPM.

Le total global ne mesure pas uniquement l'effet des corrections : la
couverture diffère (`NPM uniquement` avant contre `NPM + NVD` après), avec
une base NVD locale et un nouveau résultat Node Audit. Les lignes
supplémentaires restent à trier et ne prouvent pas automatiquement que les
deux commits ont introduit 25 nouvelles vulnérabilités.

Preuves conservées :

- `reports/findings-before-after.diff`
- `reports/findings-normalized-delta.txt`
- `reports/findings-added-normalized.tsv`
- `reports/findings-removed-normalized.tsv`
- `reports/report-sha256.txt`

### Suite et empreintes

- `jsonwebtoken@0.4.0` reste une dépendance directe à traiter séparément.
- `express-jwt@6.0.0` introduit `jsonwebtoken@8.5.1` ; ses CVE NVD associées
  nécessitent également un tri JWT distinct.

Empreinte du rapport avant :
`d24ff738b112ed7beb5649c67dd0306a6b06cd682b4b0b1e0b4de43da975965e`

Empreinte du rapport après :
`8a21c7a94bf7441a5e3e1e68902d7cabef9397ba5c103148151a1599da3b9631`

**Conclusion : les trois findings ciblés sont résolus et vérifiés. Les autres
findings et la dette JWT restent explicitement ouverts.**

<!-- workshop3-captures-ci -->
## Captures et statut CI

| Capture | Légende |
|---|---|
| [01 — Résumé avant](../screenshots/dependency-check-01-avant-resume.png) | Rapport Dependency-Check avant correction, avec les informations du scan. |
| [02 — Détail avant](../screenshots/dependency-check-02-avant-detail.png) | Détail d'un finding ciblé avant remédiation. |
| [03 — Diff des corrections](../screenshots/dependency-check-03-diff-correction.png) | Versions PDFKit/Express-JWT et configuration explicite RS256/HS256. |
| [04 — Résumé après](../screenshots/dependency-check-04-apres-resume.png) | Rapport après retenu, produit avec Node Audit actif et les limites documentées. |
| [05 — Comparaison ciblée](../screenshots/dependency-check-05-apres-detail.png) | Trois findings présents avant et absents de l'extraction après. |
| [07 — Versions après](../screenshots/dependency-check-07-versions-apres.png) | `pdfkit@0.20.2`, `express-jwt@6.0.0` et absence de CryptoJS dans l'arbre affiché. |

La capture `dependency-check-06-build.png` reste à produire avec le run CI de
la branche Lhoussaine.

La branche est poussée au SHA `c60aca3`, mais le workflow SCA de Zineb est
absent de cette branche au moment de ces captures. Son run sur
`workshop3-pipeline-zineb` au SHA `0414ea2` n'est donc pas utilisé comme preuve
CI de Lhoussaine. L'URL du run, l'artifact et la capture 06 seront ajoutés
après intégration du workflow, sans déclarer un succès CI anticipé.
