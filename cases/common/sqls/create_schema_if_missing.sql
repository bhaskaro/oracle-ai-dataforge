-- ============================================================
-- Script: create_schema_if_missing.sql
-- Purpose:
--   - Create a user/schema if it does not exist
--   - Grant basic "regular" privileges for app schemas
--
-- Expects:
--   DEFINE p_username   = <username>
--   DEFINE p_password   = <password>
--   DEFINE p_default_ts = <tablespace>  -- e.g. USERS (local) or DATA (cloud)
--
-- Safe to run multiple times.
-- Must be run as a user with CREATE USER privilege (e.g. SYSTEM/ADMIN).
-- ============================================================
SET SERVEROUTPUT ON

DECLARE
  v_count      INTEGER;
  v_conname    VARCHAR2(30);
  v_default_ts VARCHAR2(30) := UPPER('&p_default_ts');
BEGIN
  -- Which container are we in?
  SELECT SYS_CONTEXT('USERENV','CON_NAME')
  INTO   v_conname
  FROM   dual;

  -- Protect against accidentally running in CDB$ROOT on a CDB
  IF v_conname = 'CDB$ROOT' THEN
    DBMS_OUTPUT.PUT_LINE(
      'ERROR: You are connected to CDB$ROOT. ' ||
      'Please connect to a PDB (e.g., FREEPDB1) to create local users like ' ||
      UPPER('&p_username')
    );
    RAISE_APPLICATION_ERROR(-20001,
      'Connected to CDB$ROOT; cannot create local user ' || UPPER('&p_username'));
  END IF;

  -- Check if user already exists
  SELECT COUNT(*)
  INTO   v_count
  FROM   dba_users
  WHERE  username = UPPER('&p_username');

  IF v_count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Creating user/schema: ' || UPPER('&p_username') ||
                         ' with default tablespace ' || v_default_ts);

    EXECUTE IMMEDIATE
      'CREATE USER ' || UPPER('&p_username') ||
      ' IDENTIFIED BY ' || '&p_password' ||
      ' DEFAULT TABLESPACE ' || v_default_ts ||
      ' TEMPORARY TABLESPACE TEMP ' ||
      ' QUOTA UNLIMITED ON ' || v_default_ts;

    EXECUTE IMMEDIATE
      'GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE, ' ||
      'CREATE VIEW, CREATE PROCEDURE TO ' || UPPER('&p_username');

    -- In both local + cloud this is typically OK; adjust if needed
    EXECUTE IMMEDIATE
      'GRANT UNLIMITED TABLESPACE TO ' || UPPER('&p_username');

    DBMS_OUTPUT.PUT_LINE('User created and privileges granted.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('User/schema already exists: ' || UPPER('&p_username'));
  END IF;
END;
/
