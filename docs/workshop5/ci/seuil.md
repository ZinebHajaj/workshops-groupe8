# Seuil de blocage — Workshop 5 (volet 3, Zineb)

## Réglage retenu
| Réglage | Jobs de preuve (SARIF, table, SBOM) | Étape bloquante |
|---|---|---|
| `severity` | `HIGH,CRITICAL` | `CRITICAL` |
| `exit-code` | `0` | `1` |
| `ignore-unfixed` | `true` | `true` |
| `timeout-minutes` | 15 (job) | 15 (job) |

## Justification
- **CRITICAL bloque** : une CVE CRITICAL corrigeable doit être traitée avant fusion.
- **HIGH est affiché et archivé, mais ne bloque pas** tant que le tri (volet 2, Hasna) n'est pas stabilisé : un pipeline rouge en permanence finit par être ignoré.
- **`exit-code: 1`** : sans code de sortie non nul, Trivy renvoie toujours 0 et le job reste vert.
- **`ignore-unfixed: true`** : on ne bloque pas sur un risque qu'aucune mise à jour ne peut fermer (3 alertes HIGH/CRITICAL sans correctif au scan de référence) ; elles sont documentées et acceptées dans le volet 2.
- **Évolution prévue** : passer à `HIGH,CRITICAL` dans l'étape bloquante une fois le stock ramené à zéro.

## Image scannée
- Scan de référence (avant remédiation) : `bkimminich/juice-shop:latest`, digest `sha256:42843723a7bf4246aa5d63c324978b17ef296ac78434aeddd34c427bfb5853f4`.
- Après remédiation : image construite depuis `Dockerfile.durci` (Hasna).

La CI analyse l'image de référence épinglée par digest. L'image durcie du volet 2 (`juice-shop-durci:workshop5`) a été évaluée localement : elle n'est pas publiée dans un registre, donc elle n'est pas scannée par la CI. Les deux jeux de constats sont identiques (écart nul, cf. `remediation/avant-apres.md`), ce qui rend la dérogation applicable aux deux.

## Dérogations

Date de décision : 2026-11-04  
Auteur : Hasna Elhassani (volet 2) — revue : Zineb Hajaj (volet 3)  
Date de réexamen : 2027-02-02 (90 jours)

### Constats dérogés (image durcie juice-shop-durci:workshop5)

| Identifiant | Paquet | Installée | Corrigée |
|---|---|---|---|
| CVE-2015-9235 | jsonwebtoken | 0.1.0 | 4.2.2 |
| CVE-2015-9235 | jsonwebtoken | 0.4.0 | 4.2.2 |
| CVE-2019-10744 | lodash | 2.4.2 | 4.17.12 |
| CVE-2023-46233 | crypto-js | 3.3.0 | 4.2.0 |
| CVE-2026-106445 | handlebars | 4.7.9 | 4.7.10 |
| CVE-2026-106446 | handlebars | 4.7.9 | 4.7.10 |
| CVE-2026-59873 | tar | 6.2.1 | 7.5.19 |
| CVE-2026-71851 | crypto-js | 3.3.0 | 4.0.0 |

### Justification

- Les 8 constats CRITICAL sont tous portés par des paquets **npm dans `node_modules`**, donc dans les couches applicatives de l'image amont ;
- l'image amont est **distroless** (pas de shell, pas d'APT, pas de `useradd`) — preuve : `docs/workshop5/remediation/preuves/essai-gabarit-apt-echec.txt` ;
- les fermer exige de **reconstruire l'application**, impossible ici (`npm ci` échoue en `ERESOLVE`, défaut connu depuis le workshop 3) ;
- aucun chemin d'exploitation n'a été prouvé : toutes les lignes du tri portent la mention « non vérifié » (`docs/workshop5/remediation/01-tri-cve.md`).

### Portée exacte

**constats CRITICAL de l'image `juice-shop-durci:workshop5`, rien d'autre.**

- Ne couvre pas les HIGH, ni les secrets, ni la configuration ;
- N'est pas reconductible tacitement : elle expire à la date de réexamen 2027-02-02 ;
- Prouve que le gate bloque toujours sur toute CVE non listée (voir `preuves-derogation.txt`, test D).

### Référence

`docs/workshop5/remediation/preuves-derogation.txt` (tests A/B/C/D) · `docs/workshop5/remediation/README.md` §7

## Actions épinglées par SHA (tag en commentaire dans le workflow)
| Action | Tag | Commit |
|---|---|---|
| actions/checkout | v7.0.1 | `3d3c42e5aac5ba805825da76410c181273ba90b1` |
| aquasecurity/trivy-action | v0.36.0 | `ed142fd0673e97e23eac54620cfb913e5ce36c25` |
| github/codeql-action/upload-sarif | v4.39.2 | `1fc58d04a4d4374f921bdac573c3811c240f9c26` |
| actions/upload-artifact | v7.0.2 | `cf430e030ddbb5b0abf93d22962f4752f3646cd9` |

Raison : en mars 2026, 76 des 77 tags de `trivy-action` ont été réécrits vers du code malveillant (CVE-2026-33634). Un SHA ne peut pas être réécrit. Sources : Aqua Security (« Trivy supply chain attack: what you need to know »), Socket (20 mars 2026), Endor Labs (CVE-2026-33634).
