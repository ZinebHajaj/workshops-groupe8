# Résultats Semgrep mesurés sur le dépôt (à recopier dans le README)

Mesures faites avec `semgrep 1.182.1` sur le clone du dépôt (`workshop2-lhoussaine`), configs :
`p/default` + `p/owasp-top-ten` + `p/secrets` + `.semgrep.yml` (règles maison),
exclusions : `*.tf`, `data/**`, `**/*.spec.ts`, `ftp/**`, `i18n/**`.

## 1. Effet du calibrage des règles (à raconter dans le rapport)

| Étape | Findings | ERROR | WARNING |
|---|---|---|---|
| v1 — règles maison non calibrées (run #7 du pipeline) | 117 | 65 | 49 |
| v2 — mêmes règles, sévérité enfin lue correctement | 117 | 65 | 49 |
| **v3 — règles calibrées + exclusions** | **30** | **8** | **21** |

> L'écart 65 → 8 n'est pas de la triche : 57 findings étaient des **faux positifs**
> ou du **code pédagogique volontairement vulnérable**. Détail dans la section 3.

## 2. Les 8 vulnérabilités ERROR restantes (toutes dans du code applicatif réel)

| Fichier:ligne | Règle | Catégorie | À corriger par |
|---|---|---|---|
| `routes/login.ts:34` | `groupe8-sql-injection-concat` | CWE-89 Injection SQL | Zainabe / Hasna |
| `routes/search.ts:23` | `groupe8-sql-injection-concat` | CWE-89 Injection SQL | Zainabe / Hasna |
| `routes/userProfile.ts:65` | `code-string-concat` | CWE-95 Code dynamique | Hasna |
| `routes/captcha.ts:22` | `groupe8-eval-usage` | CWE-95 `eval()` | Hasna |
| `lib/xml.ts:12` | `groupe8-eval-usage` | CWE-95 `eval()` | (bonus) |
| `routes/currentUser.ts:31` | `remote-property-injection` | CWE-915 Pollution de prototype | (bonus) |
| `frontend/src/hacking-instructor/index.ts:126` | `groupe8-xss-innerhtml` | CWE-79 XSS | Zainabe |
| `frontend/src/hacking-instructor/index.ts:142` | `groupe8-xss-innerhtml` | CWE-79 XSS | Zainabe |

**C'est la liste de travail de l'équipe** : le gate reste rouge tant qu'il en reste.
Quand les correctifs de Zainabe et Hasna arrivent, le compteur doit tomber à 0 →
run vert → la démonstration « rouge puis vert » est complète.

## 3. Pourquoi 57 findings ont été écartés (section « limites » du README)

| Cause | Nombre | Explication |
|---|---|---|
| Faux positifs de ma propre règle `groupe8-sql-injection-concat` | ~30 | le pattern `$DB.get($A + $B)` matchait `this.http.get(this.host + '/api/...')` d'Angular HttpClient dans `frontend/src/app/Services/*.ts` — appels HTTP, pas du SQL. Règle resserrée sur `.query/.run/.prepare/.exec`. |
| Code pédagogique de Juice Shop | 4 | `data/static/codefixes/*.ts` sont des snippets **volontairement** vulnérables fournis par l'application (challenges « code fix »). Ce n'est pas du code de l'équipe → exclu. |
| Données de test / faux secrets | 4 | `data/static/users.yml` (utilisateurs de démo) et tokens JWT dans les `*.spec.ts` → exclus. |
| Terraform d'infrastructure | 12 | règles AWS (`*.tf`) hors périmètre du workshop → exclus (`--exclude='*.tf'`). |
| Actions épinglées par tag (`@v4` au lieu d'un SHA) | 9 | `github-actions-mutable-action-tag` : WARNING, non bloquant. À mentionner comme bonne pratique (épingler par SHA). |

## 4. Ce que ça démontre (pour la conclusion)

1. Un outil SAST brut produit **beaucoup de bruit** : sans calibrage, un gate à 65 ERROR est inutilisable — personne ne le fait passer au vert, donc l'équipe le désactive.
2. Le calibrage (exclusions + règles resserrées) est **un travail d'ingénierie à part entière**, pas un réglage cosmétique.
3. Le **dédoublonnage par localisation** du gate évite de compter deux fois la même faille signalée par deux règles (on est passé de 11 à 8 ERROR pour cette raison).
4. Un gate n'a de valeur que si son **seuil** est crédible : 0 nouvelle finding ERROR = objectif atteignable.

## 5. Mesure de la baseline (gate sur le code nouveau)

Mesure faite sur la branche `workshop2-lhoussaine`, avec les règles **telles que présentes dans le
dépôt** (`.semgrep.yml` v1) et la commande exacte du workflow :

```bash
MB=$(git merge-base HEAD origin/workshop2)

# scan complet
semgrep scan --config=p/default --config=p/secrets --config=.semgrep.yml \
  --exclude='*.tf' --exclude='data/**' --exclude='**/*.spec.ts' --metrics=off --sarif . 

# scan avec baseline
semgrep scan --config=p/default --config=p/secrets --config=.semgrep.yml \
  --exclude='*.tf' --exclude='data/**' --exclude='**/*.spec.ts' --metrics=off \
  --baseline-commit "$MB" --sarif .
```

| Scan | Findings | ERROR | Interprétation |
|---|---|---|---|
| Complet (tout le dépôt) | 86 | **53** | passif de Juice Shop + faux positifs Angular |
| **Avec `--baseline-commit` (merge-base)** | **9** | **0** | ne reste que ce que la branche apporte → **gate vert** |

> **Choix de conception assumé.** Le gate est appliqué au *code nouveau*, pas au passif :
> Semgrep tourne avec `--baseline-commit` (merge-base avec `workshop2`). Les vulnérabilités héritées
> restent comptabilisées dans l'état initial et documentées (§2), mais toute **nouvelle** finding de
> sévérité ERROR introduite par une PR bloque le merge. C'est le comportement standard d'un SAST en CI —
> sans cela, aucun projet existant ne peut activer un gate.
>
> La capture `docs/ci/03-gate-echec.png` (run rouge, `VERDICT : PIPELINE BLOQUE`) prouve que le
> blocage fonctionne réellement : ce run-là avait été fait **sans** baseline, avec un `eval()` introduit
> volontairement.

## 6. Pièges rencontrés (à citer en soutenance)

1. **`result.level` est `null` dans le SARIF Semgrep** : la sévérité est dans
   `tool.driver.rules[].defaultConfiguration.level`. Un gate qui filtre sur `result.level` compte
   0 finding et laisse tout passer (bug trouvé puis corrigé).
2. **`--baseline-commit` silencieusement inopérant** : si le SHA de la branche de base n'est pas dans
   le clone, Semgrep fait un scan complet sans rien signaler. D'où le `git fetch` + `merge-base`
   explicites dans le workflow, et un `::warning::` si aucune baseline n'est trouvée.
3. **Règles trop larges = faux positifs en masse** : `$DB.get($A + $B)` matchait
   `this.http.get(this.host + '/api/...')` d'Angular HttpClient (~30 faux positifs).
4. **YAML fragile** : un `message:` non quoté contenant `" : "` invalide **toute** la config ;
   Semgrep retourne alors 0 finding au lieu d'échouer bruyamment.
