#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   Load both tables to N rows:
#     ./run_case13_local.sh load 500
#
#   Cleanup (drop both tables):
#     ./run_case13_local.sh cleanup
#
# Defaults:
#   ./run_case13_local.sh load        # uses 100 rows

ACTION="${1:-load}"      # load | cleanup
P_TARGET_ROWS="${2:-100}"

# --- Config ---
CONTAINER_NAME="oracle-ai-db"   	# your DB container name
DB_USER="system"					# DB user
DB_PASS="welcome1"					# DB password
DB_SERVICE="FREEPDB1"				# PDB/service name
SQL_DIR_IN_CONTAINER="/opt/sql"		# where .sql lives inside container

case "${ACTION}" in
  load)
    echo "==> Loading TABLE_CASE13_SRC and TABLE_CASE13_TARGET to ${P_TARGET_ROWS} rows..."

    docker exec -i "${CONTAINER_NAME}" \
      sqlplus -s "${DB_USER}/${DB_PASS}@${DB_SERVICE}" <<EOF
SET FEEDBACK ON
SET SERVEROUTPUT ON
DEFINE p_target_rows = ${P_TARGET_ROWS}
@${SQL_DIR_IN_CONTAINER}/table_case13_src_loader.sql
@${SQL_DIR_IN_CONTAINER}/table_case13_target_loader.sql
EXIT
EOF
    ;;

  cleanup)
    echo "==> Cleaning up TABLE_CASE13_SRC and TABLE_CASE13_TARGET..."

    docker exec -i "${CONTAINER_NAME}" \
      sqlplus -s "${DB_USER}/${DB_PASS}@${DB_SERVICE}" <<EOF
SET FEEDBACK ON
SET SERVEROUTPUT ON
@${SQL_DIR_IN_CONTAINER}/case13_cleanup.sql
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

