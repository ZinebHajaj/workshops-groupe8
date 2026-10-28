# Workshop 2 — Sécurité du Code Source : SAST avec SonarQube & Semgrep

**Groupe 8** — Zineb Hajaj · Hasna elhassani · Ouzziki Lhoussaine
**Projet analysé :** OWASP Juice Shop (Node.js / Angular / TypeScript)
**Dépôt :** https://github.com/ZinebHajaj/workshops-groupe8

---

## 1. Objectif

Ce workshop met en place une **analyse statique de sécurité (SAST)** sur une application volontairement vulnérable, puis l'intègre dans un **pipeline CI** qui bloque automatiquement toute nouvelle vulnérabilité.

Trois objectifs :

1. Configurer **SonarQube** (via Docker) et **Semgrep** sur le code du projet ;
2. Détecter puis **corriger** des vulnérabilités intentionnelles (injections, XSS, mauvaises pratiques) ;
3. **Comparer** les deux outils pour comprendre leurs limites, leur complémentarité et leurs cas d'usage.

## 2. Outils utilisés

| Outil | Version | Rôle |
|---|---|---|
| SonarQube Community | `lts-community` (Docker) | Analyse globale : bugs, vulnérabilités, *code smells*, *security hotspots*, Quality Gate |
| Semgrep | `semgrep/semgrep:latest` (+ `p/default`, `p/owasp-top-ten`, `p/secrets`, `.semgrep.yml`) | Détection de patterns de sécurité précis, rapide, règles personnalisables |
| GitHub Actions | — | Orchestration du pipeline CI |
| Docker / Docker Compose | — | Exécution locale de SonarQube |

## 3. Organisation du dépôt (branches)

```
main                    version stable / rendu final
 └── workshop2          branche du workshop 2 (intégration)
      ├── workshop2-zainabe   SonarQube + Docker
      ├── workshop2-hasna     Semgrep
      └── workshop2-lhoussaine    Pipeline CI + README
```

Convention : une branche par workshop créée depuis `main`, une branche par personne créée depuis la branche du workshop, intégration uniquement par **Pull Request**.

## 4. Pipeline CI (GitHub Actions)

Fichier : `.github/workflows/security-pipeline.yml`

```
 push / pull_request
        │
        ▼
 ┌──────────────┐   ┌────────────────────────────┐   ┌──────────────────────┐
 │ 1. Checkout  │   │ 2a. SonarQube (Docker)     │   │ 2b. Semgrep          │
 │    du code   │──▶│   démarrage + scan         │   │   scan + SARIF       │
 └──────────────┘   │   + Quality Gate           │   │   + Code Scanning    │
                    └────────────────────────────┘   └──────────────────────┘
                                   │                          │
                                   ▼                          ▼
                        ┌──────────────────────────────────────────┐
                        │ 3. SECURITY GATE (scripts/security-gate.sh)│
                        │   ÉCHEC si :                              │
                        │    • ≥ 1 nouvelle finding Semgrep ERROR   │
                        │    • Quality Gate SonarQube = FAILED      │
                        └──────────────────────────────────────────┘
```

**Étapes clés :**

1. **Checkout** — `actions/checkout@v4` avec `fetch-depth: 0` (historique complet nécessaire au calcul du *new code*).
2. **SonarQube** — le serveur `sonarqube:lts-community` est démarré dans le runner, un token d'analyse est généré via l'API, puis `sonar-scanner` analyse le projet ; le Quality Gate est récupéré par `sonarqube-quality-gate-action`.
3. **Semgrep** — scan avec les règles communautaires **et** les règles maison de `.semgrep.yml`, sortie **SARIF** publiée dans l'onglet *Security → Code scanning* de GitHub. Le mode `--baseline-commit` limite le rapport aux **nouvelles** findings.
4. **Security gate** — script Bash qui agrège les deux rapports et **fait échouer le pipeline** si les seuils sont dépassés. C'est ce gate qui empêche une PR vulnérable d'être mergée.

> Captures : `docs/ci/` (run vert, détail des jobs, SARIF dans Code Scanning)

## 5. Résultats SonarQube

_(à compléter par Zainabe — captures dans `docs/sonarqube/`)_

| Métrique | Avant | Après |
|---|---|---|
| Vulnerabilities | | |
| Security Hotspots | | |
| Bugs | | |
| Quality Gate | | |

Vulnérabilités corrigées : voir [`docs/vulnerabilites-zainabe.md`](docs/vulnerabilites-zainabe.md)

## 6. Résultats Semgrep

_(à compléter par Hasna — captures dans `docs/semgrep/`)_

| Configuration | Findings ERROR | Findings WARNING |
|---|---|---|
| `p/default` | | |
| `p/owasp-top-ten` | | |
| `.semgrep.yml` (règles maison) | | |

Vulnérabilités corrigées : voir [`docs/vulnerabilites-hasna.md`](docs/vulnerabilites-hasna.md)

## 7. Comparaison SonarQube vs Semgrep

_(synthèse du tableau détaillé de Hasna : [`docs/comparaison-sonarqube-semgrep.md`](docs/comparaison-sonarqube-semgrep.md))_

| Critère | SonarQube | Semgrep |
|---|---|---|
| Approche | Analyse sémantique complète (AST, flux de données, moteur multi-langages) | Correspondance de patterns (`pattern`, `pattern-either`, `taint mode`) |
| Couverture | Très large : bugs, vulnérabilités, maintenabilité, duplication, couverture | Ciblée sécurité + patterns personnalisés |
| Rapidité | Lent (serveur + indexation, plusieurs minutes) | Très rapide (quelques secondes à minutes) |
| Configuration | `sonar-project.properties` + serveur | Fichier YAML lisible, pas de serveur |
| Faux positifs | Nombreux (règles génériques, style) | Faibles si les règles sont bien écrites |
| Qualité de la règle | Standardisée, non modifiable (CE) | Totalement personnalisable, versionnée avec le code |
| Intégration CI | Serveur à héberger + token + Quality Gate | Binaire/conteneur autonome, SARIF natif |
| Cas d'usage idéal | Suivi global de la qualité et de la dette technique dans le temps | Contrôle de pattern en pré-commit / PR, règles métier, secrets |

**Complémentarité** : SonarQube donne la **vue d'ensemble et la tendance** ; Semgrep donne le **contrôle fin, rapide et sur mesure**. Les deux se recoupent partiellement (ex. injection SQL) mais chacun détecte des vulnérabilités que l'autre manque. C'est pour cela que le pipeline exécute **les deux en parallèle** derrière un gate unique.

## 8. Difficultés rencontrées et limites

- SonarQube nécessite un serveur (≈ 2 Go de RAM) : démarrage de 1 à 3 min dans le runner, `vm.max_map_count` à ajuster pour Elasticsearch.
- L'édition **Community** ne gère pas l'analyse multi-branches ni les *pull request decorations* → un seul projet par dépôt.
- Le premier scan considère tout le code comme « nouveau » : le Quality Gate échoue nécessairement au run initial (baseline).
- Semgrep, sans baseline, remonte beaucoup de findings sur un projet volontairement vulnérable comme Juice Shop → nécessité de filtrer (`--baseline-commit`, exclusions) puis de trier les faux positifs.
- Corriger une vulnérabilité dans Juice Shop peut casser une fonctionnalité (l'app est pédagogiquement piégée) : chaque correctif a été revérifié avec `npm start`.

## 9. Reproduire en local

```bash
git clone https://github.com/ZinebHajaj/workshops-groupe8.git
cd workshops-groupe8
git checkout main

# 1) Application
npm install
npm start                     # http://localhost:3000

# 2) SonarQube
docker compose -f infrastructure/docker-compose.sonarqube.yml up -d
# http://localhost:9000  (admin / admin, changement de mot de passe imposé)

# 3) Semgrep
docker run --rm -v "$PWD:/src" semgrep/semgrep \
  semgrep scan --config=p/default --config=p/owasp-top-ten --config=.semgrep.yml /src

# 4) Le gate, à la main
./scripts/security-gate.sh semgrep.sarif sonar-quality-gate.txt
```

## 10. Conclusion

Ce workshop montre qu'une **analyse SAST en CI** est un garde-fou concret : sans gate, les alertes restent des rapports ignorés ; avec un gate, une vulnérabilité critique **empêche le merge**. La comparaison des deux outils montre aussi qu'il n'existe pas d'outil unique : la valeur vient de la **combinaison** d'une analyse sémantique large (SonarQube) et de règles de patterns rapides et personnalisables (Semgrep), pilotées par une politique de blocage claire.

## 11. Répartition du travail

| Membre | Tâche |
|---|---|
| Zineb Hajaj | SonarQube + Docker : scan, captures du dashboard, correction de 2-3 vulnérabilités |
| Hasna elhassani | Semgrep : installation, scan, captures, correction de 2-3 vulnérabilités différentes + tableau comparatif |
| Ouzziki Lhoussaine | Pipeline GitHub Actions (checkout, SonarQube, Semgrep, security gate) + README final  |
