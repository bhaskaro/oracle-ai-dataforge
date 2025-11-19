#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./run_case13_cloud.sh load 500         # schema VOGGU, 500 rows
#   ./run_case13_cloud.sh cleanup          # schema VOGGU
#   ./run_case13_cloud.sh load 500 SCHEMA2 # override schema

ACTION="${1:-load}"           # load | cleanup
P_TARGET_ROWS="${2:-100}"     # only used for 'load'
TARGET_SCHEMA="${3:-VOGGU}"   # default schema

# --- Cloud DB / wallet config ---
export TNS_ADMIN="/opt/oracle/wallet"  # adjust if needed
DB_USER="ADMIN"                        # ADB admin user
DB_ALIAS="MYADB_HIGH"                 # TNS alias from tnsnames.ora

SQL_DIR_CASE="/opt/cases/case13/sqls"
SQL_DIR_COMMON="/opt/cases/common/sqls"

SCHEMA_PASSWORD="${CASE_SCHEMA_PASSWORD:-welcome1}"

case "${ACTION}" in
  load)
    echo "==> [case13-cloud] Loading TABLE_CASE13_SRC & TABLE_CASE13_TARGET"
    echo "    Schema: ${TARGET_SCHEMA}"
    echo "    Row target: ${P_TARGET_ROWS}"
    echo "    (Cloud: DATA tablespace; will auto-create schema if missing)"

    sqlplus -s "${DB_USER}@${DB_ALIAS}" <<EOF
WHENEVER SQLERROR EXIT SQL.SQLCODE
SET FEEDBACK ON
SET SERVEROUTPUT ON

-- 1) Ensure schema exists (CLOUD: DATA tablespace)
DEFINE p_username   = ${TARGET_SCHEMA}
DEFINE p_password   = ${SCHEMA_PASSWORD}
DEFINE p_default_ts = DATA
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
    echo "==> [case13-cloud] Cleanup: Dropping CASE13 tables from schema ${TARGET_SCHEMA}"

    sqlplus -s "${DB_USER}@${DB_ALIAS}" <<EOF
WHENEVER SQLERROR EXIT SQL.SQLCODE
SET FEEDBACK ON
SET SERVEROUTPUT ON

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
