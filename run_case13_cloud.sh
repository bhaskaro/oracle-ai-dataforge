#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   Load both tables to N rows:
#     ./run_case13_cloud.sh load 500
#
#   Cleanup (drop both tables):
#     ./run_case13_cloud.sh cleanup
#
# Defaults:
#   ./run_case13_cloud.sh load        # uses 100 rows

ACTION="${1:-load}"      # load | cleanup
P_TARGET_ROWS="${2:-100}"

# --- Config ---
export TNS_ADMIN="/opt/oracle/wallet"  # wallet / tnsnames / sqlnet
DB_USER="ADMIN"                        # or your schema user
DB_ALIAS="MYADB_HIGH"                  # TNS alias (tnsnames.ora)
SQL_DIR="/opt/sql"                     # path to .sql on this host

case "${ACTION}" in
  load)
    echo "==> Loading TABLE_CASE13_SRC and TABLE_CASE13_TARGET to ${P_TARGET_ROWS} rows (cloud DB)..."

    sqlplus -s "${DB_USER}@${DB_ALIAS}" <<EOF
SET FEEDBACK ON
SET SERVEROUTPUT ON
DEFINE p_target_rows = ${P_TARGET_ROWS}
@${SQL_DIR}/table_case13_src_loader.sql
@${SQL_DIR}/table_case13_target_loader.sql
EXIT
EOF
    ;;

  cleanup)
    echo "==> Cleaning up TABLE_CASE13_SRC and TABLE_CASE13_TARGET (cloud DB)..."

    sqlplus -s "${DB_USER}@${DB_ALIAS}" <<EOF
SET FEEDBACK ON
SET SERVEROUTPUT ON
@${SQL_DIR}/case13_cleanup.sql
EXIT
EOF
    ;;

  *)
    echo "Usage:"
    echo "  ${0} load [row_count]"
    echo "  ${0} cleanup"
    exit 1
    ;;
esac

