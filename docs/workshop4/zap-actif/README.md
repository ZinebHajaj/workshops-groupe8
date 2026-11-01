# Workshop 4 — Scan actif OWASP ZAP (Zineb Hajaj, Groupe 8)

Cible : OWASP Juice Shop 20.3.0, instance locale (Docker, réseau zap-net). Détail complet : [resultats.md](resultats.md), [correlation.md](correlation.md), [perimetre.txt](perimetre.txt), [scope.context](scope.context).

## Résultat en bref
- 155 URLs explorées, 19 alertes : 0 High, 5 Medium, 5 Low, 9 Informational.
- Confirmées par rejeu manuel : Backup File Disclosure, Bypassing 403, CORS, Full Path Disclosure, Feature-Policy obsolète.
- Aucune alerte XSS ni injection : non détectées par ce scan, ce qui ne prouve pas leur absence (application Angular, spider 2 min, sans AJAX spider, non authentifié).
- Aucune alerte de cookie (HttpOnly, Secure, SameSite) sans connexion.

## 1. Périmètre et cible
![Périmètre](../screenshots/zap-actif-01-perimetre.png)
![Cible locale](../screenshots/zap-actif-02-cible-locale.png)
![Conteneur Docker](../screenshots/zap-actif-03-docker-ps.png)
![Contexte ZAP](../screenshots/zap-actif-04-contexte.png)

## 2. Scan actif
![Commande du scan](../screenshots/zap-actif-05-fullscan-execution.png)
![Fin du scan](../screenshots/zap-actif-06-fullscan-fin.png)
![Sommaire du rapport](../screenshots/zap-actif-07-rapport-sommaire.png)

## 3. XSS et injections : non détectées
![XSS](../screenshots/zap-actif-08-xss-non-detecte.png)
![Injections](../screenshots/zap-actif-09-injection-non-detectee.png)

## 4. Rejeu manuel
![Rejeu curl](../screenshots/zap-actif-10-rejeu-manuel.png)
![Divulgation de chemin](../screenshots/zap-actif-10b-rejeu-path-disclosure.png)
![Dangerous JS Functions](../screenshots/zap-actif-08b-dangerous-js.png)

## 5. Corrélation avec le workshop 2 (SAST)
![Corrélation](../screenshots/zap-actif-11-correlation.png)

## 6. Commit
![git log](../screenshots/zap-actif-12-git.png)
