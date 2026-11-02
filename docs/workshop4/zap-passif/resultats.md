# Résultats OWASP ZAP — scan passif (baseline) — Workshop 4

## Cadre et autorisation

- Responsable : Ouzziki Lhoussaine
- Branche : workshop4-zap-passif-lhoussaine
- Commit analysé : 5dc18a61ca08a7a0452722f943a0da05de2a6608
- Cible : http://juice-shop-groupe8:3000 — instance Juice Shop locale lancée par moi (Docker),
  propriétaire : moi-même sur ma machine, autorisation : auto-autorisée, aucun système tiers visé.
- Type de scan : PASSIF (zap-baseline.py), NON authentifié.
- Date UTC du run retenu : 2026-10-31, exécution entre 18:20:05Z et ~18:22Z.
- Environnement : Linux 7.0.0-38-generic x86_64, Docker 29.9.2, Git 2.53.0.

## Images utilisées

| Rôle | Référence | Digest | Créée le |
|---|---|---|---|
| Cible | bkimminich/juice-shop:latest (version 20.3.0) | sha256:42843723a7bf4246aa5d63c324978b17ef296ac78434aeddd34c427bfb5853f4 | 2026-10-12T14:53:52Z |
| Scanner | ghcr.io/zaproxy/zaproxy:stable | sha256:030d3df57735dacbb83464854758e674dd9ad01d79d12a129a8e58b1fd384238 | 2026-10-26T13:34:27Z |

Méthode de démarrage : B (image publiée). Le build local depuis le `Dockerfile` a échoué
(`npm error code ERESOLVE`) ; l'échec est conservé dans `logs/docker-build-echec.log.txt`.
Cause identifiée : régression sur `main` introduite par la PR dependabot n° 21
(`vitest` porté à ^5.0.5 alors que `@vitest/coverage-v8` reste en ^4.1.2).

## Commande exécutée

docker run --rm --network zap-net -t \
  -v "$PWD/docs/workshop4/zap-passif/reports:/zap/wrk/:rw" \
  ghcr.io/zaproxy/zaproxy:stable zap-baseline.py \
  -t http://juice-shop-groupe8:3000 \
  -r zap-baseline.html -J zap-baseline.json -w zap-baseline.md -x zap-baseline.xml \
  -a -I 2>&1 | tee docs/workshop4/zap-passif/logs/zap-baseline.log.txt

## Résultat d'exécution

- Code de sortie : **0**
- Résumé console : `FAIL-NEW: 0  WARN-NEW: 10  PASS: 61`
- Portée : 116 URLs explorées ; **16 alertes nommées**, **10 identifiants de plugin**, 24 URLs concernées.
- Rapports : `reports/zap-baseline.{html,json,md,xml}` + `reports/zap.yaml`
- Journal : `logs/zap-baseline.log.txt`
- Empreintes SHA-256 : voir `commandes.txt`

### Réconciliation 16 alertes / 10 plugins

Le résumé d'exécution compte des **identifiants de plugin**, le rapport JSON des **alertes nommées**.
Trois plugins produisent plusieurs alertes : `[10049]` en produit 3, `[90004]` en produit 2,
`[90005]` en produit 4 → 10 + 2 + 1 + 3 = **16**. Vérification : `jq '[.site[].alerts[].pluginid] | unique | length'` → 10.

## Constats — cookies (exigence de l'énoncé)

Les règles `Cookie No HttpOnly Flag [10010]`, `Cookie Without Secure Flag [10011]` et
`Cookie without SameSite Attribute [10054]` sont en état **PASS** : elles se sont exécutées et
n'ont rien trouvé. La raison est observée directement :

| Parcours testé | `Set-Cookie` reçus |
|---|---|
| `GET /` | 0 |
| `GET /rest/products/search?q=apple` | 0 |
| `POST /rest/user/login` (compte fictif, échec attendu, HTTP 401) | 0 |

**Conclusion à conserver telle quelle** : aucune réponse observée n'émet de cookie ; les attributs
`HttpOnly` / `Secure` / `SameSite` sont donc **non applicables sur ce périmètre non authentifié**.
Ce n'est pas une preuve de bonne configuration des cookies, c'est l'absence de cookie à évaluer.
L'espace authentifié n'est pas couvert par ce scan.

## Constats — en-têtes de sécurité

En-têtes réellement renvoyés par la cible sur `GET /` :

    Access-Control-Allow-Origin: *
    X-Content-Type-Options: nosniff
    X-Frame-Options: SAMEORIGIN
    Feature-Policy: payment 'self'
    Cache-Control: public, max-age=0

| En-tête | État observé | Règle ZAP correspondante |
|---|---|---|
| Content-Security-Policy | **absent** | `[10038]` WARN — réel |
| Access-Control-Allow-Origin | **`*`** (toutes origines) | `[10098]` WARN — réel |
| Feature-Policy | présent mais **obsolète** | `[10063]` WARN — réel (faible) |
| Permissions-Policy | **absent** (remplacé par Feature-Policy) | via `[10063]` |
| Cross-Origin-Embedder-Policy | **absent** | `[90004]` WARN — réel (faible) |
| Cross-Origin-Opener-Policy | **absent** | `[90004]` WARN — réel (faible) |
| Strict-Transport-Security | non évalué (cible en **HTTP**) | `[10035]` **PASS** — non applicable |
| X-Frame-Options | `SAMEORIGIN` | `[10020]` **PASS** — cohérent |
| X-Content-Type-Options | `nosniff` | `[10021]` **PASS** — cohérent |

## Tableau des alertes (16)

| # | Alerte (libellé exact ZAP) | Risque | Confiance | Occ. | URL d'exemple | Statut | Correction proposée |
|---|---|---|---|---|---|---|---|
| 1 | Content Security Policy (CSP) Header Not Set | Medium | High | 5 | http://juice-shop-groupe8:3000 | Réel | Ajouter une CSP restrictive (tester sans casser l'app) |
| 2 | Cross-Domain Misconfiguration | Medium | Medium | 5 | http://juice-shop-groupe8:3000 | Réel | Restreindre `Access-Control-Allow-Origin` aux origines connues |
| 3 | Deprecated Feature Policy Header Set | Low | Medium | 5 | http://juice-shop-groupe8:3000 | Réel (faible) | Remplacer `Feature-Policy` par `Permissions-Policy` |
| 4 | Cross-Origin-Embedder-Policy Header Missing or Invalid | Low | Medium | 5 | http://juice-shop-groupe8:3000 | Réel (faible) | Ajouter COEP si isolation cross-origin nécessaire |
| 5 | Cross-Origin-Opener-Policy Header Missing or Invalid | Low | Medium | 5 | http://juice-shop-groupe8:3000 | Réel (faible) | Ajouter COOP (`same-origin`) |
| 6 | Full Path Disclosure | Low | Low | 6 | .../ftp/coupons_2013.md.bak | **Réel — confirmé par rejeu** | Gestionnaire d'erreurs générique, aucune trace de pile côté client |
| 7 | Dangerous JS Functions | Low | Low | 2 | .../chunk-Cv2YgWUq.js | Réel mais attendu (`bypassSecurityTrustHtml`) | À corréler avec le scan actif (XSS DOM) — hors périmètre passif |
| 8 | Base64 Disclosure | Info | Medium | 11 | http://juice-shop-groupe8:3000/ftp | **Faux positifs** (police, PNG data-URI, nom haché) | Aucune |
| 9 | Modern Web Application | Info | Medium | 5 | http://juice-shop-groupe8:3000 | Informationnel (reconnaissance) | Aucune |
| 10 | Storable and Cacheable Content | Info | Medium | 1 | .../robots.txt | Informationnel | Revoir `Cache-Control` sur contenu dynamique |
| 11 | Storable but Non-Cacheable Content | Info | Medium | 5 | http://juice-shop-groupe8:3000 | Informationnel | Aucune |
| 12 | Non-Storable Content | Info | Medium | 1 | .../ftp/eastere.gg | Informationnel | Aucune |
| 13 | Sec-Fetch-Dest Header is Missing | Info | High | 4 | .../assets/public/favicon_js.ico | Artefact de scanner | Aucune (en-têtes émis par le navigateur) |
| 14 | Sec-Fetch-Mode Header is Missing | Info | High | 4 | .../assets/public/favicon_js.ico | Artefact de scanner | Aucune |
| 15 | Sec-Fetch-Site Header is Missing | Info | High | 4 | .../assets/public/favicon_js.ico | Artefact de scanner | Aucune |
| 16 | Sec-Fetch-User Header is Missing | Info | High | 4 | .../assets/public/favicon_js.ico | Artefact de scanner | Aucune |

## Biais et limites observés

- Le spider a suivi des **URLs fabriquées à partir des traces de pile**
  (`/juice-shop/build/routes/fileServer.js:52:13`, `/juice-shop/node_modules/express/lib/router/layer.js:95:5`).
  Une partie des 116 URLs est donc du bruit : la couverture réelle est inférieure à 116 pages utiles.
- Ce bruit est lui-même un constat : la divulgation de chemins internes alimente la reconnaissance.
- Le scan a provoqué une erreur applicative (`/ftp/...`) : les journaux Juice Shop mentionnent
  un challenge « Error Handling » résolu. Le scan est passif, mais le spider génère de vraies requêtes.

## Ce que ce scan ne dit pas

- Un scan passif **non authentifié** ne teste ni XSS, ni injection, ni contournement d'authentification
  ou de contrôle d'accès : ces vérifications relèvent du scan actif (Zineb), sur instance locale autorisée.
- `FAIL-NEW: 0` signifie « aucune règle classée FAIL ne s'est déclenchée sur les URLs explorées »,
  **pas** « l'application est sûre ».
- La cible est une instance de test en **HTTP**, non durcie : les attentes liées à HTTPS
  (HSTS, cookie `Secure`) ne sont pas évaluables ici.
- Un seul run retenu (31/10) ; les rapports de la session du 30/10 ont été remplacés par ce run.

## Corrections priorisées (proposées, non appliquées)

1. Gestionnaire d'erreurs générique (supprimer les chemins et traces de pile) — `Full Path Disclosure`.
2. Politique CSP — `CSP Header Not Set`.
3. Restriction CORS — `Access-Control-Allow-Origin: *`.
4. Migration `Feature-Policy` → `Permissions-Policy`, ajout COOP/COEP — durcissement.

Aucune correction n'a été appliquée : le code applicatif n'est pas modifié pendant ce workshop,
ces propositions servent la discussion risques/corrections du rapport d'équipe.

## Preuves visuelles (docs/workshop4/screenshots/)

| Capture | Ce qu'elle prouve |
|---|---|
| zap-01-branche-et-dossiers.png | branche de travail + arborescence des preuves |
| zap-02-juice-shop-docker-ps.png | cible lancée : image, port publié sur 127.0.0.1 |
| zap-03-juice-shop-navigateur.png | application réellement servie |
| zap-04-accessibilite-conteneur.png | cible joignable depuis le réseau Docker de ZAP (200) |
| zap-05-version-digest.png | digests des deux images + version 20.3.0 |
| zap-06-baseline-execution.png | exécution du baseline : Automation Framework, 116 URLs |
| zap-07-baseline-resume.png | résultat du run : FAIL 0 / WARN 10 / PASS 61 |
| zap-08-rapport-html-sommaire.png | rapport HTML : ZAP 2.17.0, 0/2/5/9 alertes, 0 faux positif marqué |
| zap-09-rapport-cookies.png | règles cookies en PASS + réponse 401 sans aucun Set-Cookie |
| zap-10a-detail-csp.png | détail de l'alerte CSP (risque, confiance, URLs) |
| zap-10b-detail-cors.png | preuve textuelle Access-Control-Allow-Origin: * |
| zap-10c-detail-coep.png | détail de l'alerte COEP (paramètre évalué) |
| zap-11-rapport-json.png | évidences extraites du JSON (Full Path Disclosure, Base64) |
| zap-12-git-commit.png | commit des preuves (ajouté après le commit) |
