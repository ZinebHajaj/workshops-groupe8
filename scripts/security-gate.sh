#!/usr/bin/env bash
# =============================================================================
# security-gate.sh - Decision finale du pipeline SAST (v2)
# Auteur : Ouzziki Lhoussaine - Groupe 8
#
# Usage :
#   ./scripts/security-gate.sh <semgrep.sarif> <sonar-quality-gate.txt>
#
# Variables d'environnement :
#   MAX_SEMGREP_ERRORS   nombre de findings ERROR tolerees (defaut : 0)
#   FAIL_ON_SONAR_GATE   "true" pour bloquer si le Quality Gate echoue (defaut : true)
#
# Code de sortie : 0 = OK (pipeline vert) | 1 = gate bloque
#
# IMPORTANT (v2) : Semgrep n'ecrit PAS la severite dans result.level (il vaut null).
# La severite reelle se trouve dans tool.driver.rules[].defaultConfiguration.level.
# La v1 filtrait sur .level et ne bloquait donc jamais. Corrige ici.
# =============================================================================
set -uo pipefail

SEMGREP_SARIF="${1:-reports/semgrep.sarif}"
SONAR_GATE_FILE="${2:-reports/sonar-quality-gate.txt}"
MAX_SEMGREP_ERRORS="${MAX_SEMGREP_ERRORS:-0}"
FAIL_ON_SONAR_GATE="${FAIL_ON_SONAR_GATE:-true}"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
FAILED=0

# Extrait une ligne par finding : <severite>\t<regle>\t<fichier>:<ligne>
# 1) severite du resultat si presente
# 2) sinon celle de la definition de la regle (defaultConfiguration.level)
# 3) sinon properties["security-severity"] (score CVSS : >=7 error, >=4 warning)
# 4) sinon "warning"
SARIF_JQ='
  [ .runs[] as $run
    | ($run.tool.driver.rules // []) as $rules
    | $run.results[]?
    | . as $r
    | ( ($rules | map(select(.id == $r.ruleId)) | .[0].defaultConfiguration.level)
        // $r.level
        // (if ($r.properties["security-severity"] // "") != ""
            then (($r.properties["security-severity"] | tonumber) as $s
                  | if $s >= 7 then "error" elif $s >= 4 then "warning" else "note" end)
            else null end)
        // "warning" ) as $lvl
    | "\($lvl)\t\($r.ruleId)\t\($r.locations[0].physicalLocation.artifactLocation.uri // "?"):\($r.locations[0].physicalLocation.region.startLine // 0)"
  ] | .[]
'

echo "=============================================================="
echo " SECURITY GATE - Workshop 2 (SonarQube + Semgrep)"
echo "=============================================================="

# ---------------------------------------------------------------- Semgrep ----
echo ""
echo "--- [1/2] Semgrep ---------------------------------------------------"
if [ -f "$SEMGREP_SARIF" ]; then
  FINDINGS=$(jq -r "$SARIF_JQ" "$SEMGREP_SARIF" 2>/dev/null || true)
  if [ -z "$(printf '%s' "$FINDINGS" | tr -d '[:space:]')" ] && [ -z "$(jq -r '.runs[].results[]? | .ruleId' "$SEMGREP_SARIF" 2>/dev/null)" ]; then
    TOTAL=0; ERRORS=0; WARNINGS=0; NOTES=0
  else
    TOTAL=$(printf '%s\n' "$FINDINGS" | grep -c . || true)
    ERRORS=$(printf '%s\n' "$FINDINGS" | awk -F'\t' '$1=="error"' | grep -c . || true)
    WARNINGS=$(printf '%s\n' "$FINDINGS" | awk -F'\t' '$1=="warning"' | grep -c . || true)
    NOTES=$(printf '%s\n' "$FINDINGS" | awk -F'\t' '$1=="note"' | grep -c . || true)
  fi

  echo "  Findings totales : $TOTAL"
  echo "  ERROR            : $ERRORS   (seuil autorise : $MAX_SEMGREP_ERRORS)"
  echo "  WARNING          : $WARNINGS"
  echo "  NOTE             : $NOTES"

  if [ "${TOTAL:-0}" -gt 0 ]; then
    echo ""
    printf "  %-50s %-8s %s\n" "REGLE" "SEVERITE" "NB"
    printf "  %-50s %-8s %s\n" "--------------------------------------------------" "--------" "--"
    printf '%s\n' "$FINDINGS" | awk -F'\t' 'NF==3 {c[$2"\t"$1]++} END {for (k in c) print c[k]"\t"k}' \
      | sort -t$'\t' -k1,1nr \
      | awk -F'\t' '{printf "  %-50s %-8s %s\n", $2, $3, $1}'

    echo ""
    echo "  Localisation des findings ERROR :"
    printf '%s\n' "$FINDINGS" | awk -F'\t' '$1=="error"' | head -20 \
      | awk -F'\t' '{printf "    %s - %s\n", $3, $2}'
    [ "$ERRORS" -gt 20 ] && echo "    ... (tronque)"
  fi

  if [ "${ERRORS:-0}" -gt "$MAX_SEMGREP_ERRORS" ]; then
    echo -e "  ${RED}[ECHEC]${NC} $ERRORS vulnerabilite(s) ERROR detectee(s) par Semgrep."
    FAILED=1
  else
    echo -e "  ${GREEN}[OK]${NC} Semgrep : aucune vulnerabilite bloquante."
  fi

  # Garde-fou : un rapport vide peut signifier un scan qui n'a rien analyse
  if [ "${TOTAL:-0}" -eq 0 ]; then
    echo -e "  ${YELLOW}[INFO]${NC} 0 finding : verifier que le scan a bien couvert le code (--verbose)."
  fi
else
  echo -e "  ${RED}[ECHEC]${NC} Rapport Semgrep introuvable ($SEMGREP_SARIF)."
  FAILED=1
fi

# -------------------------------------------------------------- SonarQube ----
echo ""
echo "--- [2/2] SonarQube Quality Gate ------------------------------------"
SONAR_OUTCOME="unknown"
[ -f "$SONAR_GATE_FILE" ] && SONAR_OUTCOME=$(tr -d '[:space:]' < "$SONAR_GATE_FILE")

echo "  Resultat brut : $SONAR_OUTCOME"
case "$SONAR_OUTCOME" in
  success)
    echo -e "  ${GREEN}[OK]${NC} Quality Gate SonarQube : PASSED."
    ;;
  failure|"")
    echo -e "  ${RED}[ECHEC]${NC} Quality Gate SonarQube : FAILED."
    [ "$FAIL_ON_SONAR_GATE" = "true" ] && FAILED=1
    ;;
  *)
    echo -e "  ${YELLOW}[ATTENTION]${NC} Statut Quality Gate indetermine ($SONAR_OUTCOME)."
    ;;
esac

# ------------------------------------------------------------------ Verdict ----
echo ""
echo "=============================================================="
if [ "$FAILED" -eq 0 ]; then
  echo -e " ${GREEN}VERDICT : PIPELINE AUTORISE (gate PASSED)${NC}"
  echo "=============================================================="
  if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
    {
      echo "## Security Gate : PASSED"
      echo ""
      echo "| Outil | Findings ERROR | Statut |"
      echo "|---|---|---|"
      echo "| Semgrep | ${ERRORS:-?} | OK |"
      echo "| SonarQube | - | ${SONAR_OUTCOME} |"
    } >> "$GITHUB_STEP_SUMMARY"
  fi
  exit 0
else
  echo -e " ${RED}VERDICT : PIPELINE BLOQUE (gate FAILED)${NC}"
  echo " Corrigez les vulnerabilites puis relancez le pipeline."
  echo "=============================================================="
  if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
    {
      echo "## Security Gate : ECHEC"
      echo ""
      echo "| Outil | Findings ERROR | Statut |"
      echo "|---|---|---|"
      echo "| Semgrep | ${ERRORS:-?} (seuil ${MAX_SEMGREP_ERRORS}) | ECHEC |"
      echo "| SonarQube | - | ${SONAR_OUTCOME} |"
      echo ""
      echo "Le pipeline est bloque. Corrigez les points du log puis relancez."
    } >> "$GITHUB_STEP_SUMMARY"
  fi
  exit 1
fi

