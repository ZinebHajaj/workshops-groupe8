# Comparaison Semgrep vs SonarQube (Workshop 2 - SAST)

Projet analysé : OWASP Juice Shop.

## Tableau de comparaison

| Critère | Semgrep | SonarQube |
|---|---|---|
| Installation | `pipx install semgrep`, quelques minutes | Docker + serveur, plus long |
| Commande / lancement | `semgrep scan --config auto` | Analyse envoyée au serveur SonarQube |
| Temps d'analyse | 4 min 25 s (sous WSL, disque `/mnt/c`) | [temps de Zainabe] |
| Fichiers analysés | 1173 fichiers, 408 règles | 37k lignes de code |
| Résultat global | 53 findings (tous bloquants) | 184 issues |
| Répartition | sécurité uniquement | 75 sécurité, 104 fiabilité, 38 maintenabilité |
| Sévérité | tous « Blocking » | 18 Blocker, 10 High, 122 Medium, 62 Low |
| Types détectés | injections, XSS, directory listing, Terraform (TLS, logs, IP publique) | sécurité, bugs, code smells, duplications (11,3 %) |
| Couverture de tests | non applicable | 0,0 % |
| Interface | terminal + rapport JSON | tableau de bord web |
| Règles personnalisées | YAML, simple | plus complexe |
| Intégration CI | une ligne dans GitHub Actions | demande un serveur accessible |
| Quality gate | non | Passed (portée « nouveau code ») |

## Exemples de détections

- **Semgrep** : `eval(code)` avec données de requête Express, listing de répertoires (`/ftp`, `/encryptionkeys`), XSS dans un template Pug, TLS faible sur le load balancer, logs CloudWatch non chiffrés.
- **SonarQube** : désactivation de la sanitisation Angular (Blocker), protocoles en clair, générateur pseudo-aléatoire non sûr, `eval()` du captcha (règle S1523).
- **Recoupement** : l'`eval()` est signalé par les deux outils (SonarQube S1523 sur le captcha, Semgrep `code-string-concat`).

## Analyse

Les deux outils ne détectent pas les mêmes choses. Semgrep s'est montré efficace sur le backend et l'infrastructure (Terraform), tandis que SonarQube couvre surtout le frontend Angular et la qualité du code (bugs, duplications, dette technique).

Le nombre de résultats n'est pas comparable : SonarQube compte aussi les bugs et les code smells, alors que Semgrep ne fait que de la sécurité.

Le quality gate de SonarQube est « Passed » malgré 18 issues Blocker, car il s'applique par défaut au nouveau code. Il faut le configurer pour bloquer réellement en CI.

Le scan Semgrep a duré 4 min 25 s, ce qui s'explique en partie par le téléchargement des règles et par WSL sur le disque Windows.

## Conclusion

Les deux outils sont complémentaires. Semgrep est léger, sans serveur, et adapté à un pipeline CI pour bloquer les failles de sécurité. SonarQube apporte un suivi de la qualité global dans le temps. L'idéal est de combiner les deux.

## Captures

![Résumé du projet](sonarqube/screenshots/01-resume-projet.png)
![Overview sécurité](sonarqube/screenshots/02-overview-securite.png)
![Issue eval captcha](sonarqube/screenshots/03-issue-eval-captcha.png)
![Liste des issues](sonarqube/screenshots/04-liste-issues-severite.png)
