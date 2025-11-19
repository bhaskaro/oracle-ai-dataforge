-- ============================================================
-- Script: case13_cleanup.sql
-- Purpose:
--   - Drop TABLE_CASE13_SRC and TABLE_CASE13_TARGET if they exist
-- ============================================================
SET SERVEROUTPUT ON

DECLARE
  PROCEDURE safe_drop(p_table_name IN VARCHAR2) IS
  BEGIN
    BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE ' || p_table_name || ' PURGE';
      DBMS_OUTPUT.PUT_LINE('Dropped table: ' || p_table_name);
    EXCEPTION
      WHEN OTHERS THEN
        IF SQLCODE = -942 THEN
          DBMS_OUTPUT.PUT_LINE('Table not found (skipped): ' || p_table_name);
        ELSE
          RAISE;
        END IF;
    END;
  END safe_drop;
BEGIN
  safe_drop('TABLE_CASE13_SRC');
  safe_drop('TABLE_CASE13_TARGET');
END;
/

