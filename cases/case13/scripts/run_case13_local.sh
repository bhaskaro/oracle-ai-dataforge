#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./run_case13_local.sh load [row_count] [src_schema] [tgt_schema]
#   ./run_case13_local.sh cleanup [src_schema] [tgt_schema]
#
# Defaults:
#   row_count  = 100
#   src_schema = VOGGU
#   tgt_schema = same as src_schema

ACTION="${1:-load}"           # load | cleanup
P_TARGET_ROWS="${2:-100}"     # only used for 'load'

# Positional schema args:
# If ACTION=cleanup and user runs ./run_case13_local.sh cleanup VOGGU_SRC VOGGU_TGT
# then $2 is src_schema, $3 is tgt_schema, so we shift differently below.
if [ "${ACTION}" = "cleanup" ]; then
  SRC_SCHEMA="${2:-VOGGU}"
  TGT_SCHEMA="${3:-${SRC_SCHEMA}}"
else
  # load: ./run_case13_local.sh load 500 VOGGU_SRC VOGGU_TGT
  SRC_SCHEMA="${3:-VOGGU}"
  TGT_SCHEMA="${4:-${SRC_SCHEMA}}"
fi

# --- DB container + login config ---
CONTAINER_NAME="oracle-ai-db"
DB_USER="SYSTEM"
DB_PASS="welcome1"
DB_SERVICE="FREEPDB1"

SQL_DIR_CASE="/opt/cases/case13/sqls"
SQL_DIR_COMMON="/opt/cases/common/sqls"

SCHEMA_PASSWORD="${CASE_SCHEMA_PASSWORD:-welcome1}"

case "${ACTION}" in
  load)
    echo "==> [case13-local] Loading CASE13 tables"
    echo "    Rows:       ${P_TARGET_ROWS}"
    echo "    SRC schema: ${SRC_SCHEMA}"
    echo "    TGT schema: ${TGT_SCHEMA}"
    echo "    (Will auto-create schemas if missing; default TS = USERS)"

    docker exec -i "${CONTAINER_NAME}" \
      sqlplus -s "${DB_USER}/${DB_PASS}@${DB_SERVICE}" <<EOF
WHENEVER SQLERROR EXIT SQL.SQLCODE
SET FEEDBACK ON
SET SERVEROUTPUT ON

-- 1) Ensure SRC schema exists (local: USERS tablespace)
DEFINE p_username   = ${SRC_SCHEMA}
DEFINE p_password   = ${SCHEMA_PASSWORD}
DEFINE p_default_ts = USERS
@${SQL_DIR_COMMON}/create_schema_if_missing.sql

-- 2) Ensure TGT schema exists (local: USERS tablespace)
DEFINE p_username   = ${TGT_SCHEMA}
DEFINE p_password   = ${SCHEMA_PASSWORD}
DEFINE p_default_ts = USERS
@${SQL_DIR_COMMON}/create_schema_if_missing.sql

-- 3) Load SRC table(s) in SRC schema
ALTER SESSION SET CURRENT_SCHEMA=${SRC_SCHEMA};
DEFINE p_target_rows = ${P_TARGET_ROWS}
@${SQL_DIR_CASE}/table_case13_src_loader.sql

-- 4) Load TARGET table(s) in TGT schema
ALTER SESSION SET CURRENT_SCHEMA=${TGT_SCHEMA};
DEFINE p_target_rows = ${P_TARGET_ROWS}
@${SQL_DIR_CASE}/table_case13_target_loader.sql

EXIT
EOF
    ;;

  cleanup)
    echo "==> [case13-local] Cleanup CASE13 tables"
    echo "    SRC schema: ${SRC_SCHEMA}"
    echo "    TGT schema: ${TGT_SCHEMA}"

    docker exec -i "${CONTAINER_NAME}" \
      sqlplus -s "${DB_USER}/${DB_PASS}@${DB_SERVICE}" <<EOF
WHENEVER SQLERROR EXIT SQL.SQLCODE
SET FEEDBACK ON
SET SERVEROUTPUT ON

-- Cleanup in SRC schema
ALTER SESSION SET CURRENT_SCHEMA=${SRC_SCHEMA};
@${SQL_DIR_CASE}/case13_cleanup.sql

-- Cleanup in TGT schema (safe: drops missing tables with ORA-942 handling)
ALTER SESSION SET CURRENT_SCHEMA=${TGT_SCHEMA};
@${SQL_DIR_CASE}/case13_cleanup.sql

EXIT
EOF
    ;;

  *)
    echo "Usage:"
    echo "  $0 load [row_count] [src_schema] [tgt_schema]"
    echo "  $0 cleanup [src_schema] [tgt_schema]"
    exit 1
    ;;
esac
