# Résultats OWASP ZAP — scan ACTIF — Workshop 4

## Cadre et autorisation
- Responsable : Zineb Hajaj (Groupe 8) — branche workshop4-zap-actif-zineb
- Cible : http://juice-shop-zineb:3000 (instance locale Juice Shop sur réseau Docker privé zap-net, accessible sur 127.0.0.1:3000), propriétaire : moi-même, autorisation : accord de l'équipe Groupe 8
- Plage : 2026-11-01 01:22:02 UTC → 01:36:31 UTC (environ 14 min), voir perimetre.txt
- Périmètre inclus/exclu : perimetre.txt et scope.context (exclus : logout, socket.io)
- Image ZAP : ghcr.io/zaproxy/zaproxy:stable (ZAP 2.17.0), digest sha256:030d3df57735dacbb83464854758e674dd9ad01d79d12a129a8e58b1fd384238
- Juice Shop : version 20.3.0 (image bkimminich/juice-shop:latest)
- Options : -m 2 (spider 2 min), -T 60, -a (règles alpha), -I, sans AJAX spider

## Exécution
- Commande : zap-full-scan.py -t http://juice-shop-zineb:3000 -n scope.context -m 2 -T 60 -a -I -r zap-actif.html -J zap-actif.json -w zap-actif.md -x zap-actif.xml
- URLs explorées : 155
- Résumé console : FAIL-NEW 0, WARN-NEW 9, PASS 141
- Rapport : 19 alertes (High 0, Medium 5, Low 5, Informational 9)
- Code de sortie : non relevé
- Fichiers : zap-actif.html / .json / .md / .xml et zap-actif.log.txt

## Alertes retenues (Medium et Low)
| # | Alerte ZAP | Risque (confiance) | Instances (rapport JSON) | Verdict | Correction proposée |
|---|---|---|---|---|---|
| 1 | Backup File Disclosure | Medium (Medium) | 31 | Confirmé : /ftp/quarantine.bak répond 200 (capture 10) | Retirer les sauvegardes du dossier public, bloquer l'accès à /ftp |
| 2 | Bypassing 403 | Medium (Medium) | 6 | Confirmé : /ftp/eastere.gg = 403, /%2e/ftp/eastere.gg = 200 (capture 10) | Normaliser le chemin avant le contrôle d'accès |
| 3 | CORS Misconfiguration | Medium (High) | 3 | Confirmé : en-tête Access-Control-Allow-Origin: * (capture 10) | Limiter aux origines de confiance |
| 4 | Content Security Policy (CSP) Header Not Set | Medium (High) | 5 | Détecté par ZAP, non rejoué | Ajouter un en-tête Content-Security-Policy (ex. middleware helmet) |
| 5 | Cross-Domain Misconfiguration | Medium (Medium) | 5 | Détecté par ZAP, non rejoué | Même correction que le CORS |
| 6 | Full Path Disclosure | Low (Low) | 6 | Confirmé : la réponse 403 de /ftp/eastere.gg expose juice-shop/build/routes/fileServer.js:68:18 (capture 10b) | Pages d'erreur génériques, sans chemins serveur |
| 7 | Dangerous JS Functions (CWE-749) | Low (Low) | 2 | Détecté : bypassSecurityTrustHtml( dans main.js et chunk-Cv2YgWUq.js (capture 08b) ; présence de la fonction, exploitabilité non prouvée | Ne pas utiliser bypassSecurityTrustHtml avec des données contrôlables par l'utilisateur (voir correlation.md) |
| 8 | Cross-Origin-Embedder-Policy Header Missing or Invalid | Low (Medium) | 5 | Détecté par ZAP, non rejoué | Ajouter l'en-tête COEP si pertinent |
| 9 | Cross-Origin-Opener-Policy Header Missing or Invalid | Low (Medium) | 5 | Détecté par ZAP, non rejoué | Ajouter Cross-Origin-Opener-Policy |
| 10 | Deprecated Feature Policy Header Set | Low (Medium) | 5 | Confirmé : Feature-Policy: payment 'self' (capture 10) | Remplacer par Permissions-Policy |

Alertes informatives (9) : Sec-Fetch-Dest/Mode/Site/User Header is Missing, Base64 Disclosure, Modern Web Application, Storable and Cacheable Content, Storable but Non-Cacheable Content, User Agent Fuzzer. Pas de verdict : elles donnent du contexte.

## XSS et injections
Aucune alerte XSS ni injection (SQL, NoSQL, commande, LDAP, XPath) : ces règles sont en PASS dans le journal (captures 08 et 09). Cela ne prouve pas l'absence de ces failles (voir Limites).

## Cookies
Aucune alerte de cookie sans HttpOnly, sans Secure ou sans SameSite sur les pages explorées sans connexion.

## Faux positifs
Aucun faux positif classé par ZAP (False Positives : 0). Les alertes non rejouées restent à confirmer.

## Corrélation SonarQube / Semgrep
Voir correlation.md.

## Risques
- Backup File Disclosure et Bypassing 403 : exposition de fichiers internes et contournement du contrôle d'accès, à corriger en priorité.
- CORS et CSP : affaiblissent la protection contre le vol de données et les attaques XSS.
- Autres alertes : durcissement (en-têtes, messages d'erreur).

## Limites du scan actif
- XSS et injections non détectées, ce qui ne prouve pas leur absence : Juice Shop est une application Angular à page unique, spider limité à 2 minutes, AJAX spider non activé, scan non authentifié.
- 50 % des réponses lentes pendant le scan (rapport ZAP).
- Les alertes non rejouées à la main ne sont pas confirmées.
- Un scan actif ne doit viser qu'une instance de test locale ou pré-production, jamais la production.

## Comparaison avec le scan passif (Lhoussaine)
Comparaison des noms d'alertes entre zap-baseline.json (branche workshop4-zap-passif-lhoussaine) et zap-actif.json :

| | Passif | Actif |
|---|---|---|
| URLs explorées | 116 | 155 |
| Alertes | 16 | 19 |
| Medium | 2 | 5 |

- Seulement dans l'actif (4) : Backup File Disclosure, Bypassing 403, CORS Misconfiguration (trois Medium confirmés par rejeu manuel) et User Agent Fuzzer (informatif). Le scan actif envoie des requêtes construites (noms de fichiers de sauvegarde, variantes de chemin, en-tête Origin, User-Agent), ce que le scan passif ne fait pas.
- Seulement dans le passif (1) : Non-Storable Content (informatif). Les deux scans n'ont pas exploré exactement les mêmes URLs.
- Les 15 autres alertes sont communes aux deux scans.
- Aucun des deux scans n'a détecté de XSS ni d'injection.
