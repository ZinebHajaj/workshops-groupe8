# Passation — du volet 3 (Zineb) vers le volet 2 (Hasna)

## Où en est le pipeline
- Workflow `.github/workflows/trivy-image.yml` terminé et testé en rouge : run #2, `Total: 8 (CRITICAL: 8)`, `exit code 1`.
- L'image scannée est aujourd'hui l'image de référence, épinglée par digest (variable `IMAGE_REF`, ligne 17).
- Les actions restent épinglées par SHA : ne pas les remplacer par des tags.
- **Le seuil ne s'assouplit pas pour faire passer un run.** Si un CRITICAL corrigeable reste, on le corrige ; sinon on le documente comme dérogation dans `docs/workshop5/ci/seuil.md` (raison et date).

## Ce qu'il faut pour obtenir le run vert
1. Pousser la branche `workshop5-trivy-remediation-hasna` avec le `Dockerfile.durci` et le tableau de tri (section 12 du README).
2. Dans `.github/workflows/trivy-image.yml`, faire deux modifications :
   - juste après `actions/checkout`, ajouter une étape qui construit l'image :
     ```yaml
           - name: Construire l'image durcie
             run: docker build -f <chemin/Dockerfile.durci> -t juice-shop-durci:ci <dossier-contexte>
     ```
   - remplacer la valeur de `IMAGE_REF` par `juice-shop-durci:ci`.
   Si l'image est publiée sur un registre, mettre sa référence **épinglée par digest** dans `IMAGE_REF`, sans étape de build.
3. Pousser : le workflow se lance tout seul. Résultat attendu : toutes les étapes vertes, y compris « Trivy - seuil de blocage (CRITICAL) ».
   Cette étape de build n'a pas encore été exécutée : vérifier le premier run avant de l'annoncer.

## Tableau avant / après à remplir (section 13 du README)
| Mesure | Avant (run #2, rouge) | Après (run vert) |
|---|---|---|
| Image | `sha256:42843723a7bf…5853f4` | à remplir |
| CRITICAL corrigeables (`ignore-unfixed`) | 8 constats, 7 CVE distinctes | à remplir |
| Étape de blocage | échec, `exit code 1` | à remplir |
| N° du run | #2 | à remplir |

## Captures à faire
- `trivy-ci-06-run-vert.png` : liste des étapes toutes vertes, avec la barre d'adresse.
- refaire `trivy-ci-01-workflow-fichier.png` si le workflow a changé.
