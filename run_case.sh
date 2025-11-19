#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Generic case runner
#
# Usage (local DB):
#   ./run_case.sh case13 load 500        # load 500 rows (case script defines defaults)
#   ./run_case.sh case13 cleanup         # cleanup / drop tables
#
#   # Any extra args are passed through to the case script, e.g. schema:
#   ./run_case.sh case13 load 500 OTHER_SCHEMA
#
# Convention:
#   For case "<case_name>", the script is:
#       cases/<case_name>/scripts/run_<case_name>_local.sh
#
#   Example:
#       case13 -> cases/case13/scripts/run_case13_local.sh
# ============================================================

if [ "$#" -lt 2 ]; then
  echo "Usage:"
  echo "  $0 <case_name> <action> [extra_args...]"
  echo
  echo "Examples:"
  echo "  $0 case13 load 500"
  echo "  $0 case13 cleanup"
  echo "  $0 case13 load 500 VOGGU"
  exit 1
fi

CASE_NAME="$1"       # e.g. case13
shift

ACTION="$1"          # e.g. load | cleanup (case script decides)
shift || true        # remaining args (if any) go through

# Build script path based on convention
CASE_SCRIPT_DIR="cases/${CASE_NAME}/scripts"
CASE_SCRIPT="${CASE_SCRIPT_DIR}/run_${CASE_NAME}_local.sh"

if [ ! -x "${CASE_SCRIPT}" ]; then
  echo "Error: Case script not found or not executable:"
  echo "  ${CASE_SCRIPT}"
  echo
  echo "Expected layout:"
  echo "  cases/${CASE_NAME}/scripts/run_${CASE_NAME}_local.sh"
  exit 1
fi

echo "==> Running ${CASE_NAME} (${CASE_SCRIPT})"
echo "    Action: ${ACTION}"
echo "    Extra args: $*"

# Call the case-specific script, passing action + remaining args
"${CASE_SCRIPT}" "${ACTION}" "$@"

