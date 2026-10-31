# Comparaison Dependabot / OWASP Dependency-Check

| Critère | Dependabot | OWASP Dependency-Check |
|---|---|---|
| Nature | Service intégré à GitHub | Outil open source OWASP |
| Rôle | Alerte et met à jour automatiquement | Détecte les vulnérabilités connues (CVE) |
| Source de données | GitHub Advisory Database | NVD (clé API recommandée) |
| Action corrective | Crée des PRs de correction | Aucune, génère un rapport |
| Mise en place | `dependabot.yml` + activation GitHub | Plugin/CLI/GitHub Action + base NVD |
| Sortie | Alertes + Pull Requests | Rapport HTML / JSON / XML |
| Support npm | Natif et complet | Via un analyseur dédié, plus limité |
| Intégration CI/CD | Native GitHub | Via pipeline (GitHub Actions) |
| Blocage du build | Non | Oui (seuil CVSS, security gate) |
| Faux positifs | Peu | Plus fréquents |
| Coût | Gratuit | Gratuit |
| Points forts | Automatisation, PRs prêtes à merger | Rapport détaillé, très configurable |
| Limites | Pas de blocage de pipeline natif | Lent au premier scan, pas de correction auto |

**Conclusion :** les deux outils sont complémentaires. Dependabot corrige et maintient les dépendances à jour en continu, Dependency-Check audite en profondeur et peut bloquer le pipeline.
