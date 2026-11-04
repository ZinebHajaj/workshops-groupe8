# Journal de l'agent — volet 2 (remédiation Trivy), branche `workshop5-trivy-remediation-hasna`

Chaque commande importante, sa sortie utile (réelle, jamais retapée à la main), la décision prise.

## Pré-vol

```
$ git --version && docker version --format '{{.Server.Version}}' && python3 --version
git version 2.53.0
29.9.2
Python 3.14.4
$ trivy --version                    # absent au départ
command not found
```
Décision : téléchargement réel de Trivy **0.75.0** (archive officielle Linux-64bit relâchée par aquasecurity), vérifié : `Version: 0.75.0`.

```
$ git clone --branch workshop5-trivy-scan-lhoussaine --single-branch https://github.com/ZinebHajaj/workshops-groupe8.git
$ git checkout -b workshop5-trivy-remediation-hasna
$ ls docs/workshop5/trivy-scan/ | wc -l
13        # 12 attendus + README.md : dossier complet, aucun fichier manquant
```

## Recouper les chiffres de départ

```
$ awk -F'\t' '{c[$1]++} END {for (s in c) print s, c[s]; print "TOTAL", NR}' docs/workshop5/trivy-scan/06-inventaire.tsv
CRITICAL 11 / HIGH 32 / MEDIUM 60 / LOW 11 / UNKNOWN 1 / TOTAL 115   # conformes au texte de mission
$ cat docs/workshop5/trivy-scan/01-digest-image.txt
digest complet : sha256:42843723a7bf…fb5853f4 (64 hex, copié de la cellule du tableau)
```

## T1 — extraire les 43

```
$ awk -F'\t' '$1=="CRITICAL" || $1=="HIGH"' docs/workshop5/trivy-scan/06-inventaire.tsv > 00-cve-a-trier.tsv
$ wc -l < 00-cve-a-trier.tsv
43
```

## T2 — les 3 sans correctif

```
$ awk -F'\t' '($1=="CRITICAL"||$1=="HIGH") && ($5==""||$5=="-")' 00-cve-a-trier.tsv | tee 00-sans-correctif.tsv
CRITICAL	CVE-2026-101894	decompress	4.2.1	-
CRITICAL	CVE-2026-53486	decompress	4.2.1	-
CRITICAL	GHSA-5mrr-rgp6-x4gr	marsdb	0.6.11	-
```
Conforme : exactement 3, les 3 attendues. Pas d'arrêt.

## T5 — Dockerfile.durci : écart majeur découvert et documenté

Le digest est recopié du fichier de référence (jamais d'une capture) : 64 caractères.

```
$ docker run --rm --entrypoint id bkimminich/juice-shop@sha256:4284…
docker: Error ... exec: "id": executable file not found in $PATH
$ docker run --rm --user node --entrypoint /bin/sh … -c whoami
docker: Error response from daemon: unable to find user node: no matching entries in passwd file
$ docker run --rm --user 1000:1000 --entrypoint /bin/sh …
docker: ... exec: "/bin/sh": stat "/bin/sh": no such file or directory
$ docker image inspect bkimminich/juice-shop@sha256:4284… --format 'USER={{.Config.User}} ENTRYPOINT={{json .Config.Entrypoint}} SHELL={{json .Config.Shell}}'
USER=65532 ENTRYPOINT=["/nodejs/bin/node"] SHELL=null
```
Conclusion : image **distroless**. Le gabarit de mission (`apt-get upgrade`, utilisateur `node`, plan B `useradd`) est inapplicable.

Essai réel du gabarit (pas de simulacre) :
```
$ docker build --no-cache -f Dockerfile.durci -t juice-shop-durci:workshop5 .
ERROR: ... process "/bin/sh -c apt-get update && ..." did not complete successfully: exit code: 1
0.467 runc run failed: ... exec: "/bin/sh": no such file or directory
```
Preuve conservée : `preuves/essai-gabarit-apt-echec.txt`.

Décisions :
- `USER 65532:65534` (non-root explicite — jamais `USER root`) ;
- `HEALTHCHECK` en forme exec via `/nodejs/bin/node` (le seul interpréteur présent) ;
- pas de `RUN` ni de `rm -rf /var/lib/apt/lists/*` : ce dernier attendu est **impossible à satisfaire honnêtement** dans une image distroless ; on documente au lieu d'écrire une commande qui n'a jamais tourné.

## T6 — trivy config sur le durci

```
$ trivy config --severity HIGH,CRITICAL Dockerfile.durci | tee 03-misconfig-durci.txt
│ Dockerfile.durci │ dockerfile │         0         │
$ grep -cE 'DS-0002|DS-0025' 03-misconfig-durci.txt
0
```

## T7 — construction et digest

```
$ docker build --no-cache -f Dockerfile.durci -t juice-shop-durci:workshop5 .
DONE   # build réel, preuve : preuves/build-durci.txt
$ docker image inspect juice-shop-durci:workshop5 --format '{{.Id}}' | tee 01-digest-image-apres.txt
sha256:075defee5bb4e624c534ef55811f2d1c4d2bc777fb6fae6d56f506141e76c059
```
Le digest vient du fichier, jamais d'une capture.

## T8 — re-scan (Trivy 0.75.0, mêmes filtres)

```
$ trivy image -f table juice-shop-durci:workshop5 | tee 04-apres.txt
$ trivy image -f json -o reports/03-apres.json juice-shop-durci:workshop5
$ python3 (script de la mission) → 06-inventaire-apres.tsv
$ awk -F'\t' '{c[$1]++} END {for (s in c) print s, c[s]; print "TOTAL", NR}' 06-inventaire-apres.tsv
CRITICAL 11 / HIGH 32 / MEDIUM 69 / LOW 11 / UNKNOWN 1 / TOTAL 124
$ diff <(awk '($1=="CRITICAL"||$1=="HIGH")' 02-avant.tsv | sort) <(awk '($1=="CRITICAL"||$1=="HIGH")' 06-inventaire-apres.tsv | sort)
(vide → les 43 lignes H+C sont identiques avant/après)
```
Explication des +9 MEDIUM (diff complet, obtenu par `comm` sur les deux TSV) :
- **+12** : 3 nouveaux CVE MEDIUM de la base rafraîchie (`CVE-2026-114690`, `CVE-2026-114691`, `CVE-2026-115455`) sur 4 paquets gcc (`gcc-14-base`, `libgcc-s1`, `libgomp1`, `libstdc++6`), versions inchangées ;
- **−3** : retirés de la base entre les deux dates — `CVE-2026-118764` ×2 (`minimatch` 3.0.5 / 3.1.5), `CVE-2026-2950` (`lodash` 2.4.2).
Net : +9. Les deux scans datent du 2026-11-01 (référence) et du 2026-11-04 (re-scan). Chaque scan est compté une seule fois — aucun re-scan n'a été rejoué pour aligner les chiffres.

## Déviations par rapport au texte de mission (et pourquoi)

| Attendu par la mission | Réalité observée | Décision |
|---|---|---|
| `apt-get upgrade` + `rm -rf /var/lib/apt/lists/*` | image distroless, pas de shell ni d'apt | documenté, pas simulé (vérif. 7 hors seuil assumée comme `non applicable`) |
| `USER node` / plan B `useradd` (uid 10001) | pas de `node` dans `/etc/passwd`, pas de `useradd` | `USER 65532:65534` (choix réellement supporté par l'image) |
| montée de version des paquets Debian | impossible par couche | signalé, fermé au chemin « image amont ré-éditée » |
| `ls docs/workshop5/trivy-scan/ \| wc -l` = 12 | 13 (README.md en plus) | complet → pas d'arrêt, noté |
| 43 alertes = 43 décisions | oui | décisions bases sur la preuve du re-scan, jamais anticipées : 40 « accepter et surveiller » quand la seule voie passe par une reconstruction, 3 déjà sans correctif |

## Points restés « non vérifié »

1. L'atteignabilité (filtre 3) des 43 chemins vulnérables : aucune preuve applicative produite, mention « non vérifié » écrite ligne par ligne dans `01-tri-cve.md`.
2. La montée de version des paquets système Debian (libc6, gcc-runtime, zlib…) : hors de portée du durcissement par couche — un chemin alternatif serait une image amont nouvelle, non testé ici.
3. Les 40 findings de configuration Terraform AWS de la référence : non re-scannés (hors périmètre du volet).
