# Tri des 43 alertes HIGH et CRITICAL

Source : `00-cve-a-trier.tsv` (extraction awk depuis `02-avant.tsv`, 43 lignes).
Décisions prises selon les 3 filtres de la méthode : (1) un correctif existe-t-il ? (2) le paquet est-il dans l'image au runtime ? (3) la fonction vulnérable est-elle atteignable depuis un chemin exposé ?

**Résultat du re-scan intégré à la preuve** (`06-inventaire-apres.tsv`) : les 40 alertes « corrigeables » (correctif publié) sont **toutes toujours présentes après le durcissement**, car elles sont portées par des paquets npm de `node_modules`, couches de l'application, qu'une couche Docker ne peut pas modifier. Leur décision honnête est donc `accepter et surveiller` (non applicable sans reconstruire l'application) assortie de la version cible — c'est une **mémoire de remédiation**, pas une déclaration de fermeture. La reconstruction de l'application est bloquée par le défaut `npm ci` ERESOLVE connu depuis le workshop 3 (README §5 et §7).

Pour le filtre (3) (atteignabilité du chemin vulnérable), la preuve n'est pas produite : chaque ligne « atteignabilité » est marquée **non vérifié** plutôt que Conclusion inventée.

| # | Identifiant | Sévérité | Paquet | Installée | Corrigée | Pourquoi elle compte ici | Décision | Preuve |
|---|---|---|---|---|---|---|---|---|
| 1 | CVE-2026-101894 | CRITICAL | decompress | 4.2.1 | — | aucun correctif publié | accepter et surveiller (mitigation : aucun fix ; surveiller le flux amont) | 00-sans-correctif.tsv ; toujours présente après (`06-inventaire-apres.tsv`) |
| 2 | CVE-2026-53486 | CRITICAL | decompress | 4.2.1 | — | idem | accepter et surveiller (mitigation : idem) | 00-sans-correctif.tsv ; toujours présente après |
| 3 | GHSA-5mrr-rgp6-x4gr | CRITICAL | marsdb | 0.6.11 | — | idem | accepter et surveiller (mitigation : idem) | 00-sans-correctif.tsv ; toujours présente après |
| 4 | CVE-2026-106445 | CRITICAL | handlebars | 4.7.9 | 4.7.10 | correctif publié, pas applicable sans reconstruire | accepter et surveiller (reconstruction à prévoir, cible ≥ 4.7.10) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 5 | CVE-2026-106446 | CRITICAL | handlebars | 4.7.9 | 4.7.10 | idem | accepter et surveiller (idem) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 6 | CVE-2023-46233 | CRITICAL | crypto-js | 3.3.0 | 4.2.0 | correctif majeur (3.x → 4.x), pas applicable sans reconstruire | accepter et surveiller (reconstruction à prévoir, cible ≥ 4.2.0) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 7 | CVE-2026-71851 | CRITICAL | crypto-js | 3.3.0 | 4.0.0 | idem | accepter et surveiller (idem) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 8 | CVE-2015-9235 | CRITICAL | jsonwebtoken | 0.1.0 | 4.2.2 | correctif majeur (0.x → 4.x), pas applicable sans reconstruire | accepter et surveiller (cible ≥ 4.2.2, mieux ≥ 9.0.0) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 9 | CVE-2015-9235 | CRITICAL | jsonwebtoken | 0.4.0 | 4.2.2 | idem (seconde copie du paquet, dédup non faite) | accepter et surveiller (idem) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 10 | CVE-2019-10744 | CRITICAL | lodash | 2.4.2 | 4.17.12 | correctif majeur (2.x → 4.x), pas applicable sans reconstruire | accepter et surveiller (cible ≥ 4.17.12) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 11 | CVE-2026-59873 | CRITICAL | tar | 6.2.1 | 7.5.19 | correctif majeur, pas applicable sans reconstruire | accepter et surveiller (cible ≥ 7.5.19) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 12 | NSWG-ECO-428 | HIGH | base64url | 0.0.6 | >= 3.0.0 | correctif majeur (0.x → 3.x) | accepter et surveiller (cible ≥ 3.0.0) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 13 | CVE-2026-102990 | HIGH | basic-ftp | 5.3.1 | 6.2.1 | correctif majeur (5.x → 6.x) | accepter et surveiller (cible ≥ 6.2.1) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 14 | CVE-2026-111181 | HIGH | body-parser | 1.20.8 | 1.20.9 / 2.4.0 | correctif mineur, pas applicable sans reconstruire | accepter et surveiller (cible ≥ 1.20.9) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 15 | CVE-2026-118664 | HIGH | decode-uri-component | 0.2.2 | 0.5.1 | correctif majeur (0.x) | accepter et surveiller (cible ≥ 0.5.1) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 16 | CVE-2020-15084 | HIGH | express-jwt | 0.1.3 | 6.0.0 | correctif majeur (0.x → 6.x) | accepter et surveiller (cible ≥ 6.0.0) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 17 | CVE-2022-25881 | HIGH | http-cache-semantics | 3.8.1 | 4.1.1 | correctif majeur (3.x → 4.x) | accepter et surveiller (cible ≥ 4.1.1) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 18 | CVE-2022-23539 | HIGH | jsonwebtoken | 0.1.0 | 9.0.0 | correctif majeur | accepter et surveiller (cible ≥ 9.0.0) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 19 | NSWG-ECO-17 | HIGH | jsonwebtoken | 0.1.0 | >= 4.2.2 | idem | accepter et surveiller (idem) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 20 | CVE-2022-23539 | HIGH | jsonwebtoken | 0.4.0 | 9.0.0 | idem (seconde version du paquet) | accepter et surveiller (idem) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 21 | NSWG-ECO-17 | HIGH | jsonwebtoken | 0.4.0 | >= 4.2.2 | idem | accepter et surveiller (idem) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 22 | CVE-2016-1000223 | HIGH | jws | 0.2.6 | >= 3.0.0 | correctif majeur (0.x → 3.x) | accepter et surveiller (cible ≥ 3.0.0) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 23 | CVE-2025-65945 | HIGH | jws | 0.2.6 | 3.2.3 / 4.0.1 | idem | accepter et surveiller (cible ≥ 3.2.3) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 24 | CVE-2018-16487 | HIGH | lodash | 2.4.2 | >= 4.17.11 | correctif majeur (2.x → 4.x) | accepter et surveiller (cible ≥ 4.17.11) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 25 | CVE-2021-23337 | HIGH | lodash | 2.4.2 | 4.17.21 | idem | accepter et surveiller (cible ≥ 4.17.21) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 26 | CVE-2026-26996 | HIGH | minimatch | 3.0.5 | 3.1.3 et sup. | correctif multi-majeurs, pas applicable sans reconstruire | accepter et surveiller (cible ≥ 3.1.3) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 27 | CVE-2026-27903 | HIGH | minimatch | 3.0.5 | 3.1.3 et sup. | idem | accepter et surveiller (idem) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 28 | CVE-2026-27904 | HIGH | minimatch | 3.0.5 | 3.1.4 et sup. | idem | accepter et surveiller (cible ≥ 3.1.4) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 29 | CVE-2017-18214 | HIGH | moment | 2.0.0 | 2.19.3 | correctif ancien, pas applicable sans reconstruire | accepter et surveiller (cible ≥ 2.19.3) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 30 | CVE-2022-24785 | HIGH | moment | 2.0.0 | 2.29.2 | idem | accepter et surveiller (cible ≥ 2.29.2) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 31 | CVE-2026-113872 | HIGH | multer | 2.4.0 | 2.5.0 | correctif mineur, pas applicable sans reconstruire | accepter et surveiller (cible ≥ 2.5.0) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 32 | CVE-2022-25887 | HIGH | sanitize-html | 1.4.2 | 2.7.1 | correctif majeur (1.x → 2.x) | accepter et surveiller (cible ≥ 2.7.1) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 33 | CVE-2026-23745 | HIGH | tar | 6.2.1 | 7.5.3 | correctif majeur | accepter et surveiller (cible ≥ 7.5.3) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 34 | CVE-2026-23950 | HIGH | tar | 6.2.1 | 7.5.4 | idem | accepter et surveiller (idem) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 35 | CVE-2026-24842 | HIGH | tar | 6.2.1 | 7.5.7 | idem | accepter et surveiller (idem) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 36 | CVE-2026-26960 | HIGH | tar | 6.2.1 | 7.5.8 | idem | accepter et surveiller (idem) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 37 | CVE-2026-29786 | HIGH | tar | 6.2.1 | 7.5.10 | idem | accepter et surveiller (idem) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 38 | CVE-2026-31802 | HIGH | tar | 6.2.1 | 7.5.11 | idem | accepter et surveiller (idem) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 39 | CVE-2026-59874 | HIGH | tar | 6.2.1 | 7.5.18 | idem | accepter et surveiller (idem) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 40 | CVE-2026-73566 | HIGH | tar | 6.2.1 | 7.5.21 | idem | accepter et surveiller (idem) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 41 | CVE-2026-109383 | HIGH | undici | 6.29.0 | 6.29.1 / 7.30.1 / 8.12.2 | correctifs mineurs puis majeurs | accepter et surveiller (cible ≥ 6.29.1) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 42 | CVE-2026-109869 | HIGH | undici | 6.29.0 | 6.29.1 / 7.30.1 / 8.12.2 | idem | accepter et surveiller (idem) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |
| 43 | CVE-2026-87018 | HIGH | undici | 6.29.0 | 6.29.1 / 7.30.1 / 8.12.2 | idem | accepter et surveiller (idem) | 00-cve-a-trier.tsv ; `06-inventaire-apres.tsv` |

## Deux observations de lecture

- `jsonwebtoken` est présent en **deux versions** (0.1.0 et 0.4.0) : c'est une dépendance transitive non dédupliquée — un même correctif s'applique deux fois, une seule ligne `package-lock` dédupliquée suffirait à fermer les deux d'un coup après reconstruction.
- `tar` porte **10 alertes** H+C (1 CRITICAL + 9 HIGH) alors que les correctifs existent depuis plusieurs versions de mineures : la dette est ancienne et volumineuse, priorité n°1 de reconstruction.

## Recencage

- 43 alertes triées, décision écrite sur chacune.
- 3 « sans correctif » : `decompress` 4.2.1 ×2 (`CVE-2026-101894`, `CVE-2026-53486`), `marsdb` 0.6.11 ×1 (`GHSA-5mrr-rgp6-x4gr`).
- 40 « corrigeables » (correctif publié) : décision `accepter et surveiller` dans ce volet, car la voie de correction passe par la reconstruction de l'application, hors périmètre d'une couche Docker. Chaque ligne porte la version cible.
