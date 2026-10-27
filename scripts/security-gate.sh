#!/usr/bin/env bash
# =============================================================================
# security-gate.sh - Decision finale du pipeline SAST
# Auteur : Ouzziki Lhoussaine  - Groupe 8
#
# Usage :
#   ./scripts/security-gate.sh <semgrep.sarif> <sonar-quality-gate.txt>
#
# Variables d'environnement :
#   MAX_SEMGREP_ERRORS   nombre de findings ERROR tolerees (defaut : 0)
#   FAIL_ON_SONAR_GATE   "true" pour bloquer si le Quality Gate echoue (defaut : true)
#
# Code de sortie : 0 = OK (pipeline vert) | 1 = gate bloque
# =============================================================================
set -uo pipefail

SEMGREP_SARIF="${1:-reports/semgrep.sarif}"
SONAR_GATE_FILE="${2:-reports/sonar-quality-gate.txt}"
MAX_SEMGREP_ERRORS="${MAX_SEMGREP_ERRORS:-0}"
FAIL_ON_SONAR_GATE="${FAIL_ON_SONAR_GATE:-true}"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
FAILED=0

echo "=============================================================="
echo " SECURITY GATE - Workshop 2 (SonarQube + Semgrep)"
echo "=============================================================="

# ---------------------------------------------------------------- Semgrep ----
echo ""
echo "--- [1/2] Semgrep ---------------------------------------------------"
if [ -f "$SEMGREP_SARIF" ]; then
  TOTAL=$(jq '[.runs[].results[]?] | length' "$SEMGREP_SARIF" 2>/dev/null || echo 0)
  ERRORS=$(jq '[.runs[].results[]? | select(.level=="error")] | length' "$SEMGREP_SARIF" 2>/dev/null || echo 0)
  WARNINGS=$(jq '[.runs[].results[]? | select(.level=="warning")] | length' "$SEMGREP_SARIF" 2>/dev/null || echo 0)
  NOTES=$(jq '[.runs[].results[]? | select(.level=="note")] | length' "$SEMGREP_SARIF" 2>/dev/null || echo 0)

  echo "  Findings totales : $TOTAL"
  echo "  ERROR            : $ERRORS   (seuil autorise : $MAX_SEMGREP_ERRORS)"
  echo "  WARNING          : $WARNINGS"
  echo "  NOTE             : $NOTES"

  if [ "$TOTAL" -gt 0 ]; then
    echo ""
    printf "  %-52s %-9s %s\n" "REGLE" "SEVERITE" "NB"
    printf "  %-52s %-9s %s\n" "----------------------------------------------------" "--------" "--"
    jq -r '[.runs[].results[]?]
           | group_by(.ruleId)
           | map({rule: .[0].ruleId, sev: (.[0].level // "warning"), n: length})
           | sort_by(-.n) | .[:20][]
           | "  \(.rule) \(.sev) \(.n)"' "$SEMGREP_SARIF" 2>/dev/null \
      | awk '{printf "  %-52s %-9s %s\n", $1, $2, $3}'
    echo ""
    echo "  Localisation des findings ERROR :"
    jq -r '.runs[].results[]? | select(.level=="error")
           | "    \(.locations[0].physicalLocation.artifactLocation.uri):\(.locations[0].physicalLocation.region.startLine) - \(.ruleId)"' \
      "$SEMGREP_SARIF" 2>/dev/null | head -20
  fi

  if [ "$ERRORS" -gt "$MAX_SEMGREP_ERRORS" ]; then
    echo -e "  ${RED}[ECHEC]${NC} $ERRORS vulnerabilite(s) ERROR detectee(s) par Semgrep."
    FAILED=1
  else
    echo -e "  ${GREEN}[OK]${NC} Semgrep : aucune nouvelle vulnerabilite bloquante."
  fi
else
  echo -e "  ${YELLOW}[ATTENTION]${NC} Rapport Semgrep introuvable ($SEMGREP_SARIF)."
  echo "  Etape ignoree (le job Semgrep a peut-etre echoue en amont)."
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
  exit 0
else
  echo -e " ${RED}VERDICT : PIPELINE BLOQUE (gate FAILED)${NC}"
  echo " Corrigez les vulnerabilites puis relancez le pipeline."
  echo "=============================================================="
  if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
    {
      echo "## Security Gate : ECHEC"
      echo ""
      echo "Le pipeline est bloque. Corrigez les points ci-dessus puis relancez."
    } >> "$GITHUB_STEP_SUMMARY"
  fi
  exit 1
fi
