#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./run_case13_local.sh load 500         # schema VOGGU, 500 rows
#   ./run_case13_local.sh cleanup          # schema VOGGU
#   ./run_case13_local.sh load 500 SCHEMA2 # override schema

ACTION="${1:-load}"           # load | cleanup
P_TARGET_ROWS="${2:-100}"     # only used for 'load'
TARGET_SCHEMA="${3:-VOGGU}"   # default schema is VOGGU

# --- DB container + login config ---
CONTAINER_NAME="oracle-ai-db"
DB_USER="SYSTEM"
DB_PASS="welcome1"
DB_SERVICE="FREEPDB1"

# Path inside the container where SQLs are mounted
SQL_DIR_CASE="/opt/cases/case13/sqls"
SQL_DIR_COMMON="/opt/cases/common/sqls"

# Password used when auto-creating schemas (change if you want)
SCHEMA_PASSWORD="${CASE_SCHEMA_PASSWORD:-welcome1}"

case "${ACTION}" in
  load)
    echo "==> [case13] Loading TABLE_CASE13_SRC & TABLE_CASE13_TARGET"
    echo "    Schema: ${TARGET_SCHEMA}"
    echo "    Row target: ${P_TARGET_ROWS}"
    echo "    (Will auto-create schema if missing)"

    docker exec -i "${CONTAINER_NAME}" \
      sqlplus -s "${DB_USER}/${DB_PASS}@${DB_SERVICE}" <<EOF
SET FEEDBACK ON
SET SERVEROUTPUT ON

-- 1) Ensure schema exists
DEFINE p_username = ${TARGET_SCHEMA}
DEFINE p_password = ${SCHEMA_PASSWORD}
DEFINE p_default_ts = USERS
@${SQL_DIR_COMMON}/create_schema_if_missing.sql

-- 2) Work in that schema
ALTER SESSION SET CURRENT_SCHEMA=${TARGET_SCHEMA};

-- 3) Load / top-up data
DEFINE p_target_rows = ${P_TARGET_ROWS}
@${SQL_DIR_CASE}/table_case13_src_loader.sql
@${SQL_DIR_CASE}/table_case13_target_loader.sql

EXIT
EOF
    ;;

  cleanup)
    echo "==> [case13] Cleanup: Dropping CASE13 tables from schema ${TARGET_SCHEMA}"
    echo "    (Will auto-create schema only if needed for ALTER SESSION; safe anyway)"

    docker exec -i "${CONTAINER_NAME}" \
      sqlplus -s "${DB_USER}/${DB_PASS}@${DB_SERVICE}" <<EOF
SET FEEDBACK ON
SET SERVEROUTPUT ON

-- Optional but harmless: ensure schema exists
DEFINE p_username = ${TARGET_SCHEMA}
DEFINE p_password = ${SCHEMA_PASSWORD}
@${SQL_DIR_COMMON}/create_schema_if_missing.sql

ALTER SESSION SET CURRENT_SCHEMA=${TARGET_SCHEMA};

@${SQL_DIR_CASE}/case13_cleanup.sql

EXIT
EOF
    ;;

  *)
    echo "Usage:"
    echo "  ${0} load [row_count] [schema]"
    echo "  ${0} cleanup [schema]"
    exit 1
    ;;
esac
