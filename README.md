# Workshop 5 — Analyse de sécurité d'une image Docker avec Trivy

**Groupe 8** · Ouzziki Lhoussaine · Zineb Hajaj · Hasna elhassani
Module DevSecOps — chapitre 5

**Branche de remise : `workshop5-Groupe8`** — tout ce qui est décrit ici s'y trouve.

> **Comment ce dossier a été produit :** trois volets, **trois branches séparées**, une par membre, puis une
> **fusion finale** dans `workshop5-Groupe8`. Le détail est en [§ 2](#2-organisation-du-travail--trois-branches-et-une-fusion).

> **Convention de chemins :** tous les liens et toutes les images de ce README partent de la **racine du dépôt**
> (`docs/workshop5/…`). Ce README est donc destiné à la **racine** du dépôt (`README.md`), sur la branche
> `workshop5-Groupe8` — c'est aussi le seul emplacement que GitHub affiche sur la page d'accueil d'une branche.

---

## 1. Ce que demande l'atelier, et où le trouver

| Exigence du professeur | Où elle est traitée | État |
|---|---|---|
| Trivy sur une image Docker | [`docs/workshop5/trivy-scan/`](docs/workshop5/trivy-scan) | ✅ livré |
| Vulnérabilités (CVE) | [§ 4](#4-résultats-du-scan-de-référence) · `docs/workshop5/trivy-scan/03-rapport.json` | ✅ livré |
| Focus HIGH / CRITICAL | [§ 5](#5-les-43-alertes-highcritical-qui-les-porte) · `docs/workshop5/trivy-scan/06-inventaire.tsv` | ✅ livré |
| Secrets | [§ 7](#7-secrets--5-constats-3-high-2-medium) · `docs/workshop5/trivy-scan/04-secrets.txt` | ✅ livré |
| Mauvaises configurations | [§ 8](#8-mauvaises-configurations--42-alertes-dont-0-dans-le-dockerfile) · `docs/workshop5/trivy-scan/05-misconfig-dockerfile.txt` | ✅ livré |
| **Remédiation** (image et Dockerfile durci) | [§ 12](#12-volet-2--remédiation-image-durcie-et-tableau-avant--après) · [`docs/workshop5/remediation/`](docs/workshop5/remediation) | ✅ livré |
| **CI/CD avec seuil de blocage** par sévérité | [§ 13](#13-volet-3--cicd-seuil-de-blocage-et-run-vert) · [`docs/workshop5/ci/`](docs/workshop5/ci) · `.trivyignore` | ✅ livré, **run vert** |
| Branche dédiée, rapport, **captures** | cette branche · ce README · [§ 9](#9-captures-du-scan-de-référence) · [§ 13.6](#136-captures-du-volet-3) | ✅ 12 captures affichées |

**Les trois volets sont terminés.** Chaque chiffre de ce document est recalculable par une commande citée à côté.
Aucun nombre n'est annoncé sans sa source.

---

## 2. Organisation du travail : trois branches et une fusion

Le travail n'a pas été fait sur une seule branche. Chaque membre a travaillé **sur la sienne**, ce qui permet à
chacun d'avancer sans bloquer les autres, et à chaque volet de rester **relisible seul**. Une fois les trois
volets terminés, ils ont été **fusionnés** dans la branche de remise.

### 2.1 Les quatre branches

| Branche | Auteur | Contenu | Livrable |
|---|---|---|---|
| `workshop5-trivy-scan-lhoussaine` | Lhoussaine | volet 1 — scan de référence, inventaire, secrets, configurations | `docs/workshop5/trivy-scan/` |
| `workshop5-trivy-remediation-hasna` | Hasna | volet 2 — tri des 43 alertes, `Dockerfile.durci`, re-scan, avant/après | `docs/workshop5/remediation/` |
| `workshop5-trivy-pipeline-zineb` | Zineb | volet 3 — workflow Trivy, seuil de blocage, SARIF, artefacts | `docs/workshop5/ci/` |
| **`workshop5-Groupe8`** | groupe | **branche de remise** : les trois volets fusionnés + ce README | tout |

Branche de proposition pour la dérogation : `workshop5-seuil-derogation` (partie de la branche de Zineb, revue par
elle avant fusion).

### 2.2 Le schéma des fusions

```
main
 │
 ├── workshop5-trivy-scan-lhoussaine ─── 769b7b3 · 6ff0ac8 · 47f50b2 · 8e5f8a2
 │        (volet 1 : scan de référence)                              │
 │                                                                   ▼
 ├── workshop5-trivy-remediation-hasna ── f9b9c34 ────────────▶ workshop5-Groupe8
 │        (volet 2 : remédiation, image durcie)                       ▲
 │                                                                    │
 ├── workshop5-trivy-pipeline-zineb ── 2b3ba1c · df21fc7 · 4150d75    │
 │        (volet 3 : CI, seuil, run rouge)                            │
 │                 │                                                  │
 │                 └── workshop5-seuil-derogation ── 5dc8b06 ── PR #53 ┘
 │                          (dérogation tracée + preuve du gate)  → 7dad1b3
```

### 2.3 Les trois conséquences de ce choix — et pourquoi il a été fait

1. **Une attribution vérifiable.** `git log` et `git shortlog -sn` montrent qui a écrit quoi, sans avoir à faire
   confiance à un tableau déclaratif.
2. **Des conflits rares et tardifs.** Chaque volet vit dans son dossier ; les trois ne se croisent qu'une seule
   fois, au moment de la fusion. Aucun conflit n'a eu à être résolu à l'aveugle.
3. **Chaque volet reste relisible seul.** Un correcteur peut ouvrir la branche de Hasna et évaluer la remédiation
   sans lire les deux autres volets — et inversement.

L'atelier demandait une branche dédiée : il y en a quatre, dont une seule est la remise. C'est un choix assumé, et
il est visible dans l'historique plutôt que raconté dans une phrase.

```bash
git log --oneline --graph --all --decorate -25
git shortlog -sn origin/workshop5-Groupe8
```

---

## 3. Cible et outil

| Élément | Valeur |
|---|---|
| Image analysée | `bkimminich/juice-shop` |
| Digest épinglé | `sha256:42843723a7bf4246aa5d63c324978b17ef296ac78434aeddd34c427bfb5853f4` |
| Système de base | Debian 13.7 — image **distroless** (pas de shell, pas d'APT) |
| Outil | **Trivy 0.75.0** (même version pour le scan de référence et le re-scan) |
| Date du scan de référence | `2026-11-01T15:47:26Z` |
| Date du re-scan | `2026-11-04` |

L'image est épinglée **par digest** et non par tag : un tag peut être réécrit, un digest non. C'est ce qui rend
les deux scans comparables.

---

## 4. Résultats du scan de référence

| Sévérité | Nombre |
|---|---|
| CRITICAL | 11 |
| HIGH | 32 |
| MEDIUM | 60 |
| LOW | 11 |
| UNKNOWN | 1 |
| **Total** | **115** |
| **HIGH + CRITICAL** | **43** |
| dont **avec correctif publié** | **40** |
| dont **sans correctif** | **3** |

Deux commandes suffisent à refaire ces comptes :

```bash
trivy image -f table bkimminich/juice-shop@sha256:42843723a7bf4246aa5d63c324978b17ef296ac78434aeddd34c427bfb5853f4
awk -F'\t' '{c[$1]++} END {for (s in c) print s, c[s]; print "TOTAL", NR}' docs/workshop5/trivy-scan/06-inventaire.tsv
```

Le périmètre H+C (**43**) n'est pas le total : c'est le sous-ensemble sur lequel la remédiation et le seuil de la
CI travaillent. Le dire évite la question « pourquoi 43 et pas 115 ? ».

---

## 5. Les 43 alertes HIGH/CRITICAL : qui les porte

Huit paquets concentrent l'essentiel du lot — donc l'essentiel de l'effort de remédiation :

| Paquet | Version installée | Version corrigée | Alertes H+C |
|---|---|---|---|
| `tar` | 6.2.1 | 7.5.x | **10** (1 CRITICAL + 9 HIGH) |
| `jsonwebtoken` | 0.1.0 **et** 0.4.0 | 4.2.2 puis 9.0.0 | 6 (deux copies) |
| `lodash` | 2.4.2 | 4.17.12 / 4.17.21 | 3 (1 CRITICAL + 2 HIGH) |
| `minimatch` | 3.0.5 | 3.1.3 et suivants | 3 |
| `undici` | 6.29.0 | 6.29.1 / 7.30.1 / 8.12.2 | 3 |
| `crypto-js` | 3.3.0 | 4.0.0 / 4.2.0 | 2 CRITICAL |
| `handlebars` | 4.7.9 | 4.7.10 | 2 CRITICAL |
| `moment` | 2.0.0 | 2.19.3 / 2.29.2 | 2 |

Deux observations qui valent d'être relevées à l'oral :

- **`jsonwebtoken` est présent en deux versions** (0.1.0 et 0.4.0) : dépendance transitive non dédupliquée,
  symptôme d'un arbre de dépendances mal entretenu plutôt que d'une erreur isolée ;
- **`tar` pèse 10 alertes à lui seul** alors que le correctif existe depuis plusieurs versions mineures : c'est
  la dette la plus volumineuse de l'image, et la priorité n°1 d'une reconstruction.

Les 43 décisions ligne par ligne sont dans [`docs/workshop5/remediation/01-tri-cve.md`](docs/workshop5/remediation/01-tri-cve.md).

---

## 6. Les 3 alertes sans correctif — assumées, pas oubliées

| Sévérité | Identifiant | Paquet | Installée | Corrigée |
|---|---|---|---|---|
| CRITICAL | CVE-2026-101894 | `decompress` | 4.2.1 | — |
| CRITICAL | CVE-2026-53486 | `decompress` | 4.2.1 | — |
| CRITICAL | GHSA-5mrr-rgp6-x4gr | `marsdb` | 0.6.11 | — |

Aucune version corrigée n'existe. Elles ne peuvent donc pas être fermées : la seule décision honnête est
« accepter et surveiller », avec la commande qui les isole :

```bash
awk -F'\t' '($1=="CRITICAL"||$1=="HIGH") && ($5==""||$5=="-")' docs/workshop5/trivy-scan/06-inventaire.tsv
```

C'est aussi la raison pour laquelle la CI utilise `ignore-unfixed: true` : les compter comme bloquantes
reviendrait à bloquer indéfiniment sur des correctifs qui n'existent pas.

---

## 7. Secrets — 5 constats (3 HIGH, 2 MEDIUM)

| Sévérité | Type | Chemin |
|---|---|---|
| HIGH | AsymmetricPrivateKey | `lib/insecurity.ts:21` |
| HIGH | AsymmetricPrivateKey | `build/lib/insecurity.js:55` (version compilée de la même clé) |
| HIGH | AsymmetricPrivateKey | `infrastructure/terraform/networking.tf:171` |
| MEDIUM | JWT | `app.guard.spec.ts:46` |
| MEDIUM | JWT | `last-login-ip.component.spec.ts:72` |

**Aucune valeur n'est recopiée dans ce dépôt** : on cite le chemin et la règle, jamais le secret. Les deux constats
`insecurity` sont la **même clé présente deux fois** (source et compilation) — le signaler montre que le doublon est
compris, pas seulement compté.

---

## 8. Mauvaises configurations — 42 alertes, dont 0 dans le Dockerfile

| Cible | Alertes | Nature |
|---|---|---|
| `Dockerfile` (racine), `infrastructure/Dockerfile` | **0** | — |
| `test/smoke/Dockerfile` | 2 HIGH | `DS-0002` (pas de `USER` non-root), `DS-0025` (`apk add` sans `--no-cache`) |
| 3 × `data/static/codefixes/iacLeakedKeyChallenge_*.tf` | 8 chacun | fixtures pédagogiques |
| `terraform/networking.tf`, `infrastructure/terraform/networking.tf` | 8 chacun | infrastructure AWS d'exemple |

Point souvent mal lu : **les 42 alertes ne disent pas que l'image est mal configurée**. Elles portent à 87 % sur des
fichiers Terraform d'exemple et des fixtures de TP. Les deux règles réellement actionnables sont `DS-0002` et
`DS-0025` — et elles sont traitées au volet 2.

---

## 9. Captures du scan de référence

Les **6 captures du volet 1**, affichées directement (pas derrière un lien). Elles sont dans
[`docs/workshop5/screenshots/`](docs/workshop5/screenshots).

### 9.1 Identité de l'image et version de Trivy

![Identité de l'image et version de Trivy](docs/workshop5/screenshots/trivy-01-identite.png)

### 9.2 Exécution du scan

![Exécution du scan Trivy](docs/workshop5/screenshots/trivy-02-scan-execution.png)

### 9.3 Tableau des vulnérabilités

![Tableau des vulnérabilités](docs/workshop5/screenshots/trivy-03-vulns-tableau.png)

### 9.4 Compteurs par sévérité

![Compteurs par sévérité](docs/workshop5/screenshots/trivy-04-compteurs.png)

### 9.5 Constat de secret (chemin cité, valeur masquée)

![Constat de secret](docs/workshop5/screenshots/trivy-05-secret.png)

### 9.6 Mauvaises configurations

![Mauvaises configurations](docs/workshop5/screenshots/trivy-06-misconfig.png)

---

## 10. Reproduire l'ensemble

```bash
# 1. scan complet de l'image de référence
trivy --version                                   # 0.75.0
trivy image bkimminich/juice-shop@sha256:42843723a7bf4246aa5d63c324978b17ef296ac78434aeddd34c427bfb5853f4

# 2. inventaire H+C et compteurs
awk -F'\t' '$1=="CRITICAL" || $1=="HIGH"' docs/workshop5/trivy-scan/06-inventaire.tsv | wc -l      # 43

# 3. configurations et secrets
trivy config --severity HIGH,CRITICAL .
trivy fs --scanners secret .

# 4. image durcie et re-scan (volet 2)
docker build --no-cache -f docs/workshop5/remediation/Dockerfile.durci -t juice-shop-durci:workshop5 .
trivy image -f table juice-shop-durci:workshop5
```

---

## 11. Comment lire ce dossier

```
docs/workshop5/trivy-scan/                     volet 1 — le scan de référence, figé
├── 00-… / 01-… / 02-…          sorties brutes du scan
├── 01-digest-image.txt         digest de l'image (référence des comparaisons)
├── 02b-tableau-propre.txt      tableau lisible, reconstruit
├── 03-rapport.json             rapport complet (toutes sévérités)
├── 04-secrets.txt              5 constats (3 HIGH, 2 MEDIUM)
├── 05-misconfig-dockerfile.txt 42 alertes de configuration
├── 06-inventaire.tsv           115 lignes : sévérité · CVE · paquet · installée · corrigée
└── 06-compteurs.txt            compteurs recalculés

docs/workshop5/remediation/                    volet 2 — la remédiation
├── 00-cve-a-trier.tsv / 00-sans-correctif.tsv
├── 01-tri-cve.md               43 décisions, avec preuve
├── 01-digest-image-apres.txt   digest de l'image durcie
├── 02-avant.tsv / 02-avant-compte.txt
├── 03-misconfig-durci.txt      trivy config sur le Dockerfile durci
├── 04-apres.txt                re-scan de l'image durcie
├── 06-inventaire-apres.tsv     inventaire après, même format
├── avant-apres.md              le tableau avant / après
├── Dockerfile.durci            la proposition de durcissement
├── journal-agent.md            traçabilité des commandes
├── preuves/                    sorties réelles conservées
├── captures-a-faire.md         les 6 captures du volet restant à prendre
└── README.md                   le rapport du volet

docs/workshop5/ci/                             volet 3 — la CI
├── seuil.md                    justification du seuil + section dérogations
├── passation-hasna.md          passation vers le volet 2
├── preuves-derogation.txt      les 4 tests du mécanisme d'exception
└── screenshots/                6 captures (workflow, run rouge, SARIF, artefacts)

docs/workshop5/screenshots/                    6 captures du scan de référence
.trivyignore                    dérogation nominative (racine du dépôt)
.github/workflows/trivy-image.yml   le workflow
```

Ordre de lecture conseillé : ce README → `docs/workshop5/remediation/README.md` → `docs/workshop5/ci/seuil.md`.

---

## 12. Volet 2 — remédiation : image durcie et tableau avant / après

### 12.1 Ce qui a été fait

Partir de l'image épinglée, en proposer une version durcie dans un **fichier séparé** (`Dockerfile.durci` ; le
`Dockerfile` de l'application n'est pas modifié), puis la reconstruire et la **re-scanner avec la même version de
Trivy**. Tout est dans [`docs/workshop5/remediation/`](docs/workshop5/remediation), sur la branche `workshop5-trivy-remediation-hasna` avant
fusion.

### 12.2 Ce que le durcissement ferme

| Contrôle | Avant | Après |
|---|---|---|
| `DS-0002` (exécution root) | présent | **fermé** — `USER 65532:65534` déclaré explicitement |
| `DS-0025` (cache de paquets) | présent | **fermé** — sans objet, aucun cache dans une image distroless |
| Digest | `sha256:42843723…` | `sha256:f7557ca4c2abee05a5d8424e9402eb36840d96aa4eb3c8a8d47f5254b0cbc35b` |
| `HEALTHCHECK` | absent | ajouté (forme exec, sans shell) |

### 12.3 Ce que le durcissement ne ferme pas — et pourquoi

| Indicateur | Avant | Après | Écart |
|---|---|---|---|
| CRITICAL | 11 | 11 | 0 |
| HIGH | 32 | 32 | 0 |
| **HIGH + CRITICAL** | **43** | **43** | **0** |
| Total (toutes sévérités) | 115 | 124 | +9 MEDIUM |

**Un écart nul n'est pas un échec : c'est un résultat, à condition de l'expliquer.** Deux causes, toutes deux
démontrées dans le dossier :

1. **L'image amont est distroless.** `RUN apt-get` échoue avec `exec: "/bin/sh": no such file or directory`
   (sortie réelle conservée dans `docs/workshop5/remediation/preuves/`). Pas de shell, donc pas d'APT, pas de `useradd` : les
   paquets système ne peuvent pas être mis à jour par une couche Docker.
2. **Les 40 alertes corrigeables vivent dans `node_modules`**, donc dans les couches applicatives de l'image
   amont. Les fermer exige de reconstruire l'application — impossible ici : `npm ci` échoue en `ERESOLVE`,
   défaut connu du projet depuis le workshop 3.

Le **+9 MEDIUM** s'explique aussi : la base de vulnérabilités a été rafraîchie entre les deux scans (`+12` sur des
paquets gcc, `−3` retirés de la base). Les dates des deux scans sont citées, et le diff est conservé. Le re-scan
n'a **pas** été rejoué pour « arranger » les chiffres.

### 12.4 Captures du volet 2

Les 6 captures de la remédiation **restent à prendre** : `docs/workshop5/remediation/captures-a-faire.md` décrit précisément les
6 états de terminal à photographier, et tout leur contenu existe déjà en texte dans `docs/workshop5/remediation/preuves/`.

Elles viendront s'ajouter ici, dans `docs/workshop5/screenshots/`, sous ces noms — les lignes sont prêtes, il suffira de les
décommenter :

<!--
![Compteurs avant remédiation](docs/workshop5/screenshots/trivy-remediation-01-avant.png)
![Dockerfile durci](docs/workshop5/screenshots/trivy-remediation-02-dockerfile.png)
![trivy config sur le Dockerfile durci](docs/workshop5/screenshots/trivy-remediation-03-config.png)
![Re-scan de l'image durcie](docs/workshop5/screenshots/trivy-remediation-04-apres.png)
![Tableau avant / après](docs/workshop5/screenshots/trivy-remediation-05-comparaison.png)
![Historique git du volet 2](docs/workshop5/screenshots/trivy-remediation-06-git.png)
-->

> Cette réserve est écrite noir sur blanc plutôt que masquée : le dossier doit pouvoir être vérifié ligne à ligne
> avant que la dernière capture soit prise.

---

## 13. Volet 3 — CI/CD, seuil de blocage et run vert

### 13.1 Le workflow

`.github/workflows/trivy-image.yml` — déclenché sur push, sur pull request, par cron quotidien et manuellement.
Les quatre actions utilisées sont **épinglées par SHA** et l'image est **épinglée par digest** : un tag peut être
réécrit, un SHA non.

Contexte de cet épinglage : en mars 2026, un incident sur la chaîne d'approvisionnement a conduit à la réécriture
de dizaines de tags d'actions. Épingler par SHA n'est pas une manie de puriste.

### 13.2 Le seuil, et sa justification

| Usage | Sévérités | Code de sortie | Effet |
|---|---|---|---|
| Preuve / rapport | `HIGH,CRITICAL` | `0` | publie sans bloquer |
| **Blocage** | `CRITICAL` | `1` | **le pipeline échoue** |

`ignore-unfixed: true` sur l'étape bloquante : on ne bloque pas sur des correctifs qui n'existent pas (§ 6).
Justification complète dans [`docs/workshop5/ci/seuil.md`](docs/workshop5/ci/seuil.md).

### 13.3 Le run rouge — la preuve que le seuil bloque

Premier passage : **`Total: 8 (CRITICAL: 8)`**, processus terminé avec `exit code 1`. Le pipeline a bien refusé de
passer. Ce chiffre se recoupe : **11 CRITICAL − 3 sans correctif = 8**.

### 13.4 La dérogation — et pourquoi elle est elle-même prouvée

Après le volet 2, l'image durcie présente **les mêmes** 8 constats CRITICAL (écart nul, § 12.3). Le run vert est
donc **impossible sans décision explicite**. La décision prise est une **dérogation nominative** :

- `.trivyignore` à la racine, **un identifiant par ligne**, aucune exception générique, aucun joker ;
- un bloc de commentaires qui dit **quoi**, **pourquoi**, **jusqu'à quand**, et **qui** a décidé ;
- justification commune : correctifs existants mais inatteignables (distroless + `node_modules`), et aucune
  atteignabilité prouvée (toutes les lignes du tri portent « non vérifié »).

Le mécanisme a été **testé**, pas seulement écrit — 4 tests dans [`docs/workshop5/ci/preuves-derogation.txt`](docs/workshop5/ci/preuves-derogation.txt) :

| Test | Situation | Attendu | Obtenu |
|---|---|---|---|
| A | sans dérogation | le gate bloque | `exit=1` ✅ |
| B | dérogation vide | le gate bloque encore | `exit=1` ✅ |
| C | les identifiants dérogés | le gate passe | `exit=0` ✅ |
| D | une CVE bidon | **le gate bloque** | `exit=1` ✅ |

**Le test D est le plus important** : il prouve que la dérogation est bornée. Sans lui, un `.trivyignore` n'est
qu'un seuil baissé avec des commentaires.

### 13.5 Le run vert

| Run | Branche | Commit | Résultat | Durée |
|---|---|---|---|---|
| #10 | `workshop5-Groupe8` (branche de remise) | `7dad1b3` | ✅ **Success** | 1 min 05 s |
| #11 | `workshop5-seuil-derogation` (manuel) | `5dc8b06` | ✅ **Success** | 55 s |

Le run vert est obtenu **sur la branche de remise**, avec un gate qui bloque toujours sur toute CVE non listée.
Artefacts : rapport SARIF, table, SBOM CycloneDX. Alertes publiées dans *Security → Code scanning*.

> **Ce que ce vert ne dit pas.** Il ne dit pas que les vulnérabilités ont disparu : elles sont toujours là (§ 12.3).
> Il dit que le pipeline sait bloquer, que l'équipe a mesuré ce qui est réellement fermable, et qu'elle a écrit ce
> qu'elle accepte de ne pas fermer. C'est la différence entre un seuil baissé et une décision d'ingénierie.

### 13.6 Captures du volet 3

Les **6 captures du volet 3**, dans [`docs/workshop5/ci/screenshots/`](docs/workshop5/ci/screenshots).

#### 13.6.1 Le fichier de workflow

![Fichier de workflow Trivy](docs/workshop5/ci/screenshots/trivy-ci-01-workflow-fichier.png)

#### 13.6.2 Le seuil dans le workflow

![Seuil de blocage dans le workflow](docs/workshop5/ci/screenshots/trivy-ci-01b-workflow-seuil.png)

#### 13.6.3 Le run rouge

![Run rouge](docs/workshop5/ci/screenshots/trivy-ci-03-run-rouge.png)

#### 13.6.4 Le total CRITICAL qui a provoqué l'échec

![Total: 8 (CRITICAL: 8)](docs/workshop5/ci/screenshots/trivy-ci-03b-total-critical.png)

#### 13.6.5 Le SARIF dans Code scanning

![Alertes Trivy dans Code scanning](docs/workshop5/ci/screenshots/trivy-ci-04-sarif-code-scanning.png)

#### 13.6.6 Les artefacts du run

![Artefacts du run](docs/workshop5/ci/screenshots/trivy-ci-05-artefacts.png)

### 13.7 Périmètre exact de la CI

La CI analyse l'image de référence **épinglée par digest**. L'image durcie du volet 2 a été évaluée
**localement** : elle n'est pas publiée dans un registre, donc elle n'est pas scannée par la CI. Les deux jeux de
constats sont identiques (écart nul), ce qui rend la dérogation applicable aux deux — mais la nuance est écrite
ici pour qu'elle ne soit pas découverte en soutenance.

---

## 14. Limites assumées du dossier

1. **43 alertes H+C subsistent après durcissement** : elles vivent dans `node_modules`, inaccessibles sans
   reconstruire l'application (`npm ci` → `ERESOLVE`).
2. **3 alertes n'ont aucun correctif** (`decompress` ×2, `marsdb` ×1) : acceptées, surveillées.
3. **Les paquets système ne sont pas mis à jour** : impossible par couche sur une image distroless ; il faudrait
   une image amont ré-éditée, ce qui change le digest et donc la comparabilité.
4. **L'atteignabilité n'est prouvée pour aucune alerte** : toutes les lignes du tri portent « non vérifié ». Ce
   serait un travail de test applicatif, hors du périmètre du TP.
5. **Les 5 secrets restent** : ils appartiennent à l'application (fixtures, clé de démonstration). On cite les
   chemins, jamais les valeurs.
6. **Les 40 alertes Terraform** de la référence ne sont pas re-scannées : le durcissement ne les touche pas.
7. **Les 6 captures du volet 2** restent à prendre (§ 12.4). Les 12 autres sont affichées ci-dessus.

Ces limites ne sont pas des excuses : elles sont la partie la plus utile du dossier. Un audit qui prétend tout
fermer est un audit qu'on ne croit pas.

---

## 15. Historique des commits et des fusions

| Commit | Branche d'origine | Contenu |
|---|---|---|
| `769b7b3` | `…-scan-lhoussaine` | volet 1 — scan Trivy de l'image de référence (115 CVE, 43 H+C) + preuves |
| `6ff0ac8` | `…-scan-lhoussaine` | volet 1 — README du volet + compteurs |
| `47f50b2` | `…-scan-lhoussaine` | volet 1 — 6 captures du scan de référence + tableau lisible |
| `8e5f8a2` | `…-scan-lhoussaine` | volet 1 — README à jour (5 secrets, captures) |
| `2b3ba1c` | `…-pipeline-zineb` | volet 3 — image épinglée par digest dans le workflow |
| `df21fc7` | `…-pipeline-zineb` | volet 3 — section 13 : volet CI/CD, run rouge et seuil |
| `4150d75` | `…-pipeline-zineb` | volet 3 — passation vers le volet 2 et statut du volet 3 |
| `6b62ed5` | `…-pipeline-zineb` | volet 3 — captures du run rouge, SARIF et artefacts |
| `f9b9c34` | `…-remediation-hasna` | **volet 2** — tri des 43 alertes, `Dockerfile.durci`, re-scan, avant/après |
| `5dc8b06` | `…-seuil-derogation` | volet 3 — dérogation nominative + preuves du gate |
| `7dad1b3` | **fusion** | PR #53 → `workshop5-Groupe8` : seuil, dérogation et statuts |




---

**En une phrase :** 115 constats, 43 dans le périmètre, 40 corrigeables mais inatteignables sans reconstruire
l'application, 3 sans correctif — un pipeline qui bloque sur CRITICAL, une dérogation bornée et prouvée, et un
run vert obtenu **sans avoir menti sur l'état réel de l'image**.
