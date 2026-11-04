# Tableau avant / après — Workshop 5, volet 2 (remédiation Trivy)

Image de départ : `bkimminich/juice-shop@sha256:42843723a7bf4246aa5d63c324978b17ef296ac78434aeddd34c427bfb5853f4` (recopié de `trivy-scan/01-digest-image.txt`, scan de référence du 2026-11-01T15:47:26Z).
Image d'arrivée : `juice-shop-durci:workshop5` — digest relevé par la commande réelle de T7 (`01-digest-image-apres.txt`, scan du 2026-11-04).

| Indicateur | Avant | Après | Écart | Explication |
|---|---|---|---|---|
| Digest de l'image | `sha256:42843723a7bf4246aa5d63c324978b17ef296ac78434aeddd34c427bfb5853f4` | `sha256:075defee5bb4e624c534ef55811f2d1c4d2bc777fb6fae6d56f506141e76c059` | nouvelle image | couche de durcissement : `USER 65532:65534` explicite + `HEALTHCHECK` (cf. T7 : `01-digest-image-apres.txt`) |
| CRITICAL | 11 | 11 | 0 | toutes portées par `node_modules` (`06-inventaire-apres.tsv`) ; les 3 sans correctif restent, les autres s'ouvrent par reconstruction de l'app, pas par une couche Docker |
| HIGH | 32 | 32 | 0 | idem — les 43 lignes H+C de `02-avant.tsv` et de `06-inventaire-apres.tsv` sont identiques (diff vide, cf. `preuves/diff-hc-vide.txt`) |
| **HIGH + CRITICAL** | **43** | **43** | **0** | un écart nul n'est pas un échec : le périmètre (paquets npm) est porté par les couches de l'application, immuables sans la reconstruire — cf. README §5 et §7 |
| Corrigeables (H/C) | 40 | 40 | 0 | correctifs publiés mais inaccessibles à un durcissement par couche ; liste et versions cibles dans `01-tri-cve.md` |
| Sans correctif | 3 | 3 | 0 | `decompress` 4.2.1 ×2, `marsdb` 0.6.11 ×1 — toujours présentes après re-scan (`preuves/sans-correctif-apres.txt`), limite assumée |
| Secrets | 5 (3 HIGH, 2 MEDIUM) | 5 (3 HIGH, 2 MEDIUM) | 0 | secrets identiques avant/après (`03-rapport.json` vs `reports/03-apres.json`) ; on ne recopie aucune valeur, seulement des chemins |
| Configuration H/C (Dockerfile) | 2 (`DS-0002`, `DS-0025`) | 0 | −2 | `trivy config --severity HIGH,CRITICAL Dockerfile.durci` : 0 finding (`03-misconfig-durci.txt`) |
| Configuration H/C (Terraform AWS, hors périmètre) | 40 (4 HIGH + 4 CRITICAL, ×5 cibles) | non re-scanné | — | le durcissement ne touche pas `infrastructure/terraform` ; ce périmètre relève d'un autre volet |
| Version de Trivy | 0.75.0 | 0.75.0 | identique | comparaison valide |

Vue d'ensemble (toutes sévérités) :

| Indicateur | Avant (`02-avant.tsv`) | Après (`06-inventaire-apres.tsv`) | Écart | Explication |
|---|---|---|---|---|
| Total vulnérabilités | 115 | 124 | +9 MEDIUM | DB rafraîchie entre les 2 scans (2026-11-01 → 2026-11-04) : 3 nouveaux CVE MEDIUM (`CVE-2026-114690`, `CVE-2026-114691`, `CVE-2026-115455`) sur 4 paquets gcc (`gcc-14-base`, `libgcc-s1`, `libgomp1`, `libstdc++6`) = +12 ; retrait DB de 3 MEDIUM (`CVE-2026-118764` ×2 minimatch, `CVE-2026-2950` lodash 2.4.2) = −3 ; net +9. La même commande rejouée donne les mêmes chiffres (`compteurs-apres.txt`). |
