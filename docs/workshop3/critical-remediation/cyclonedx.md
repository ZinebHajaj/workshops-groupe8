# Correction CycloneDX — 2026-10-31

Commit : c099896
Dépendance : @cyclonedx/cyclonedx-npm, dépendance directe de développement utilisée par npm run sbom.
Avant : 4.2.1
Après : 6.0.0

Advisories :
- GHSA-v75r-vx73-82pj : versions affectées >=2.1.0 et <5.0.0, correction en 5.0.0.
- GHSA-q69g-4hcv-6jg4 : versions affectées <6.0.0, correction en 6.0.0.

La version 6.0.0 est donc la version minimale couvrant les deux advisories.
Ses prérequis Node >=20.18.0 et npm >=9 sont compatibles avec Node 22 en CI et Node 24/npm 11 en local.

Validation :
- npm ci --ignore-scripts : réussi.
- SBOM : CycloneDX 1.6, 519 composants.
- Build serveur : réussi.
- Build frontend et SBOM frontend : réussis.
- GHSA-v75r-vx73-82pj : absente du nouvel audit npm.
- GHSA-q69g-4hcv-6jg4 : absente du nouvel audit npm.

Preuves : reports/critical-remediation/cyclonedx-before.txt,
cyclonedx-after.txt, bom-cyclonedx-6.0.0.json et
npm-audit-cyclonedx-after.json.

Note : Dependency-Check affichait un score de 10.0, tandis que les pages
GitHub actuelles des deux advisories indiquent High 8.5. Les deux constats
sont conservés sans harmonisation artificielle des scores.
