# Corrélation ZAP (actif) / SAST (workshop 2) — Workshop 4

Rapports SAST réellement présents dans le dépôt et consultés :
- SonarQube : origin/workshop2-sonar-zineb : docs/vulnerabilites-zainabe.md
- Semgrep : origin/workshop2-sonar-zineb : docs/RESULTATS-semgrep.md
- Semgrep (Hasna) : origin/workshop2-sast-hasna : workshop2/semgrep/semgrep-report-complet.json

Recherche limitée aux termes bypassSecurityTrust, XSS et innerHTML.

| Alerte ZAP (libellé exact) | CWE | Rapport SAST utilisé | Fichier:ligne | Règle | Statut | Commentaire |
|---|---|---|---|---|---|---|
| Dangerous JS Functions | 749 | SonarQube : docs/vulnerabilites-zainabe.md | frontend/src/app/last-login-ip/last-login-ip.component.ts:40 | XSS : protection d'Angular désactivée (Blocker) | Corrélée (même fonction) | ZAP trouve bypassSecurityTrustHtml( dans main.js et chunk-Cv2YgWUq.js ; Sonar signale le même appel dans le code source. Rien ne prouve que ce soit exactement le même appel (ZAP ne donne pas le composant). |
| Dangerous JS Functions | 749 | Semgrep (rapport de Hasna) : semgrep-report-complet.json | — | — | Non corrélée | 0 occurrence de bypassSecurityTrust dans ce rapport : Semgrep ne l'a pas détecté. |
| (aucune alerte XSS ZAP) | — | Semgrep : docs/RESULTATS-semgrep.md | frontend/src/hacking-instructor/index.ts:126 et :142 | groupe8-xss-innerhtml (CWE-79) | Divergence | Semgrep signale un risque XSS par innerHTML ; ZAP n'a levé aucune alerte XSS. Explication probable : page non explorée (application Angular, spider 2 min, sans AJAX spider). |
| Backup File Disclosure, Bypassing 403, CORS, CSP, Full Path Disclosure | — | — | — | — | Non corrélées | ZAP seul : problèmes de configuration observés dans les réponses HTTP. Aucune correspondance identifiée dans les rapports consultés. |

## Remarques
- ZAP a scanné l'image publiée bkimminich/juice-shop:latest (version 20.3.0), pas le code corrigé de la branche workshop2-sonar-zineb. La correction Sonar (suppression de l'appel à la ligne 40, commit 2b738be) n'est donc pas visible dans ce scan.
- Un SAST lit le code source, un DAST observe l'application en fonctionnement : les deux approches se complètent.
- Une alerte corrélée n'est pas une faille exploitable prouvée.
