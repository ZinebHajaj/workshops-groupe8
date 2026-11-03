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
- Scan de référence (avant remédiation) : `bkimminich/juice-shop:latest`, digest `sha256:42843723a7bf…5853f4`.
- Après remédiation : image construite depuis `Dockerfile.durci` (Hasna).

## Dérogations
Une alerte acceptée est listée ici avec sa raison et sa date : (aucune pour l'instant).

## Actions épinglées par SHA (tag en commentaire dans le workflow)
| Action | Tag | Commit |
|---|---|---|
| actions/checkout | v7.0.1 | `3d3c42e5aac5ba805825da76410c181273ba90b1` |
| aquasecurity/trivy-action | v0.36.0 | `ed142fd0673e97e23eac54620cfb913e5ce36c25` |
| github/codeql-action/upload-sarif | v4.39.2 | `1fc58d04a4d4374f921bdac573c3811c240f9c26` |
| actions/upload-artifact | v7.0.2 | `cf430e030ddbb5b0abf93d22962f4752f3646cd9` |

Raison : en mars 2026, 76 des 77 tags de `trivy-action` ont été réécrits vers du code malveillant (CVE-2026-33634). Un SHA ne peut pas être réécrit. Sources : Aqua Security (« Trivy supply chain attack: what you need to know »), Socket (20 mars 2026), Endor Labs (CVE-2026-33634).
