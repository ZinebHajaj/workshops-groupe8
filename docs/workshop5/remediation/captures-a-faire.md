# Captures à faire — volet 2 (remédiation Trivy)

À photographier par un humain (6 états). Retaper la commande exacte ; si une sortie a déjà été produite
avec `tee`, le fichier correspondant est cité — il fait foi, la capture montre son contenu.

| Fichier attendu (dans `docs/workshop5/screenshots/`) | Commande à retaper | Ce qui doit être visible |
|---|---|---|
| `trivy-remediation-01-avant.png` | `grep -E 'CRITICAL\|HIGH\|43\|40' docs/workshop5/remediation/02-avant-compte.txt` | compteurs avant : 11 CRITICAL, 32 HIGH, 43 H+C, la commande |
| `trivy-remediation-02-dockerfile.png` | `cat docs/workshop5/remediation/Dockerfile.durci` | `Dockerfile.durci` entier, `FROM …@sha256:4284…` lisible, `USER 65532:65534` |
| `trivy-remediation-03-config.png` | `trivy config --severity HIGH,CRITICAL docs/workshop5/remediation/Dockerfile.durci` | tableau récapitulatif `0` finding, aucune occurrence de `DS-0002` ni `DS-0025` |
| `trivy-remediation-04-apres.png` | `trivy image -f table juice-shop-durci:workshop5` | le résumé du re-scan : 45 (debian 13.7) et 79 (node_modules), mêmes compteurs H+C que l'avant |
| `trivy-remediation-05-comparaison.png` | `cat docs/workshop5/remediation/avant-apres.md` | le tableau avant / après rempli, aucun `<…>` |
| `trivy-remediation-06-git.png` | `git log --oneline -5 && git status --short` | le commit du volet 2 (signé Hasnael10) + un arbre de travail propre |

Sortie de secours (sans écran) : les mêmes commandes sont jouables depuis `preuves/` — `preuves/` reste la preuve
texte autorisée si une capture est impossible ; aucune sortie fabriquée n'est admise (règle R7).
