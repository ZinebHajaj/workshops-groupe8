# Correction Basic-FTP — 2026-10-31

Commit : 84e0890
Chaîne : proxy-agent@8.0.2 -> pac-proxy-agent@9.1.0 -> get-uri@8.0.1 -> basic-ftp@5.3.1.
Correction : override npm exact basic-ftp=6.2.1.

Advisory : GHSA-c475-qrg2-pj4r.
Versions affectées : <=6.2.0.
Version corrigée : 6.2.1.

Justification :
get-uri@8.0.1 déclare encore basic-ftp ^5.3.1, donc aucune mise à jour directe
du parent ne fournit la correction. L'override ciblé évite de modifier les
autres dépendances. Le changement majeur de Basic-FTP 6 concerne les hôtes de
transfert séparés, que get-uri n'active pas. La branche amont de get-uri
utilise également Basic-FTP 6.

Validation :
- basic-ftp@6.2.1 overridden confirmé dans la chaîne.
- Import get-uri : réussi.
- Tests utils : 55/55, dont downloadToFile avec proxy HTTPS.
- Builds serveur et frontend : réussis.
- GHSA-c475-qrg2-pj4r : absente du nouvel audit npm.

Preuves : reports/critical-remediation/basic-ftp-chain.txt,
basic-ftp-after.txt et npm-audit-basic-ftp-after.json.

Dependency-Check affichait 10.0 ; la page GitHub actuelle indique High 8.2.
