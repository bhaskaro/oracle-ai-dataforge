-- ============================================================
-- Script: table_case13_target_loader.sql
-- Purpose:
--   - Ensure TABLE_CASE13_TARGET exists (create if needed)
--   - Ensure the table has at least &p_target_rows rows
--   - COL1 treated as primary key-style unique identifier
--   - Fill VARCHAR columns with random text (~80% length)
--   - Print row counts for SRC and TARGET tables
-- ============================================================

---------------------------------------------------------------
-- 1. Create TABLE_CASE13_TARGET if it does not exist
---------------------------------------------------------------
DECLARE
  v_sql VARCHAR2(32767);
BEGIN
  BEGIN
    v_sql := q'[
      CREATE TABLE TABLE_CASE13_TARGET (
        COL1   NUMBER(10),
        COL2   VARCHAR2(50 CHAR),
        COL3   VARCHAR2(50 CHAR),
        COL4   VARCHAR2(50 CHAR),
        COL5   VARCHAR2(50 CHAR),
        COL6   VARCHAR2(50 CHAR),
        COL7   VARCHAR2(50 CHAR),
        COL8   VARCHAR2(50 CHAR),
        COL9   VARCHAR2(50 CHAR),
        COL10  VARCHAR2(255 CHAR),
        COL11  VARCHAR2(50 CHAR),
        COL12  VARCHAR2(50 CHAR),
        COL13  VARCHAR2(50 CHAR),
        COL14  VARCHAR2(50 CHAR),
        COL15  VARCHAR2(50 CHAR),
        COL16  VARCHAR2(50 CHAR),
        COL17  VARCHAR2(50 CHAR),
        COL18  VARCHAR2(50 CHAR),
        COL19  VARCHAR2(50 CHAR),
        COL20  VARCHAR2(50 CHAR),
        COL21  VARCHAR2(50 CHAR),
        COL22  VARCHAR2(50 CHAR),
        COL23  VARCHAR2(50 CHAR),
        COL24  VARCHAR2(50 CHAR),
        COL25  VARCHAR2(50 CHAR),
        COL26  VARCHAR2(50 CHAR),
        COL27  VARCHAR2(50 CHAR),
        COL28  VARCHAR2(50 CHAR),
        COL29  VARCHAR2(50 CHAR),
        COL30  VARCHAR2(50 CHAR),
        COL31  VARCHAR2(50 CHAR),
        COL32  VARCHAR2(50 CHAR),
        COL33  VARCHAR2(50 CHAR),
        COL34  VARCHAR2(50 CHAR),
        COL35  VARCHAR2(50 CHAR),
        COL36  VARCHAR2(50 CHAR),
        COL37  VARCHAR2(50 CHAR),
        COL38  VARCHAR2(50 CHAR),
        COL39  VARCHAR2(50 CHAR),
        COL40  VARCHAR2(50 CHAR),
        COL41  VARCHAR2(50 CHAR),
        COL42  VARCHAR2(50 CHAR),
        COL43  VARCHAR2(50 CHAR),
        COL44  VARCHAR2(50 CHAR),
        COL45  VARCHAR2(50 CHAR),
        COL46  VARCHAR2(50 CHAR),
        COL47  VARCHAR2(50 CHAR),
        COL48  VARCHAR2(50 CHAR),
        COL49  VARCHAR2(50 CHAR),
        COL50  VARCHAR2(50 CHAR),
        COL51  VARCHAR2(50 CHAR),
        COL52  VARCHAR2(50 CHAR),
        COL53  VARCHAR2(50 CHAR),
        COL54  VARCHAR2(50 CHAR),
        COL55  VARCHAR2(50 CHAR),
        COL56  VARCHAR2(50 CHAR),
        COL57  VARCHAR2(50 CHAR),
        COL58  VARCHAR2(50 CHAR),
        COL59  VARCHAR2(50 CHAR),
        COL60  VARCHAR2(50 CHAR),
        COL61  VARCHAR2(50 CHAR),
        COL62  VARCHAR2(50 CHAR),
        COL63  VARCHAR2(50 CHAR),
        COL64  VARCHAR2(50 CHAR),
        COL65  VARCHAR2(50 CHAR),
        COL66  VARCHAR2(50 CHAR),
        COL67  VARCHAR2(50 CHAR),
        COL68  VARCHAR2(50 CHAR),
        COL69  VARCHAR2(50 CHAR),
        COL70  VARCHAR2(50 CHAR),
        COL71  VARCHAR2(50 CHAR),
        COL72  VARCHAR2(50 CHAR),
        COL73  VARCHAR2(50 CHAR),
        COL74  VARCHAR2(50 CHAR),
        COL75  VARCHAR2(50 CHAR),
        COL76  VARCHAR2(50 CHAR),
        COL77  VARCHAR2(50 CHAR),
        COL78  VARCHAR2(50 CHAR),
        COL79  VARCHAR2(50 CHAR),
        COL80  VARCHAR2(50 CHAR),
        COL81  VARCHAR2(50 CHAR),
        COL82  VARCHAR2(50 CHAR),
        COL83  VARCHAR2(50 CHAR),
        COL84  VARCHAR2(50 CHAR),
        COL85  VARCHAR2(50 CHAR),
        COL86  VARCHAR2(50 CHAR),
        COL87  VARCHAR2(50 CHAR),
        COL88  VARCHAR2(50 CHAR),
        COL89  VARCHAR2(50 CHAR),
        COL90  VARCHAR2(50 CHAR),
        COL91  VARCHAR2(50 CHAR),
        COL92  VARCHAR2(50 CHAR),
        COL93  VARCHAR2(50 CHAR),
        COL94  VARCHAR2(50 CHAR),
        COL95  VARCHAR2(50 CHAR),
        COL96  VARCHAR2(50 CHAR),
        COL97  VARCHAR2(50 CHAR),
        COL98  VARCHAR2(50 CHAR),
        COL99  VARCHAR2(50 CHAR),
        COL100 VARCHAR2(50 CHAR)
      )
    ]';

    EXECUTE IMMEDIATE v_sql;
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE != -955 THEN
        RAISE;
      END IF;
  END;
END;
/
---------------------------------------------------------------
-- 2. Populate / top-up TABLE_CASE13_TARGET to p_target_rows
---------------------------------------------------------------
DECLARE
  p_target_rows CONSTANT PLS_INTEGER := &p_target_rows;

  v_cnt       PLS_INTEGER;
  v_to_insert PLS_INTEGER;
  v_max_pk    NUMBER(10);

BEGIN
  SELECT COUNT(*)
  INTO   v_cnt
  FROM   TABLE_CASE13_TARGET;

  IF v_cnt < p_target_rows THEN
    v_to_insert := p_target_rows - v_cnt;
  ELSE
    v_to_insert := 0;
  END IF;

  IF v_to_insert > 0 THEN
    SELECT NVL(MAX(COL1), 0)
    INTO   v_max_pk
    FROM   TABLE_CASE13_TARGET;

    DBMS_RANDOM.SEED(TO_CHAR(SYSTIMESTAMP, 'FF6'));

    FOR i IN 1 .. v_to_insert LOOP
      INSERT INTO TABLE_CASE13_TARGET
      SELECT
        v_max_pk + i,                -- COL1
        DBMS_RANDOM.STRING('U',40),  -- COL2
        DBMS_RANDOM.STRING('U',40),  -- COL3
        DBMS_RANDOM.STRING('U',40),  -- COL4
        DBMS_RANDOM.STRING('U',40),  -- COL5
        DBMS_RANDOM.STRING('U',40),  -- COL6
        DBMS_RANDOM.STRING('U',40),  -- COL7
        DBMS_RANDOM.STRING('U',40),  -- COL8
        DBMS_RANDOM.STRING('U',40),  -- COL9
        DBMS_RANDOM.STRING('U',204), -- COL10
        DBMS_RANDOM.STRING('U',40),  -- COL11
        DBMS_RANDOM.STRING('U',40),  -- COL12
        DBMS_RANDOM.STRING('U',40),  -- COL13
        DBMS_RANDOM.STRING('U',40),  -- COL14
        DBMS_RANDOM.STRING('U',40),  -- COL15
        DBMS_RANDOM.STRING('U',40),  -- COL16
        DBMS_RANDOM.STRING('U',40),  -- COL17
        DBMS_RANDOM.STRING('U',40),  -- COL18
        DBMS_RANDOM.STRING('U',40),  -- COL19
        DBMS_RANDOM.STRING('U',40),  -- COL20
        DBMS_RANDOM.STRING('U',40),  -- COL21
        DBMS_RANDOM.STRING('U',40),  -- COL22
        DBMS_RANDOM.STRING('U',40),  -- COL23
        DBMS_RANDOM.STRING('U',40),  -- COL24
        DBMS_RANDOM.STRING('U',40),  -- COL25
        DBMS_RANDOM.STRING('U',40),  -- COL26
        DBMS_RANDOM.STRING('U',40),  -- COL27
        DBMS_RANDOM.STRING('U',40),  -- COL28
        DBMS_RANDOM.STRING('U',40),  -- COL29
        DBMS_RANDOM.STRING('U',40),  -- COL30
        DBMS_RANDOM.STRING('U',40),  -- COL31
        DBMS_RANDOM.STRING('U',40),  -- COL32
        DBMS_RANDOM.STRING('U',40),  -- COL33
        DBMS_RANDOM.STRING('U',40),  -- COL34
        DBMS_RANDOM.STRING('U',40),  -- COL35
        DBMS_RANDOM.STRING('U',40),  -- COL36
        DBMS_RANDOM.STRING('U',40),  -- COL37
        DBMS_RANDOM.STRING('U',40),  -- COL38
        DBMS_RANDOM.STRING('U',40),  -- COL39
        DBMS_RANDOM.STRING('U',40),  -- COL40
        DBMS_RANDOM.STRING('U',40),  -- COL41
        DBMS_RANDOM.STRING('U',40),  -- COL42
        DBMS_RANDOM.STRING('U',40),  -- COL43
        DBMS_RANDOM.STRING('U',40),  -- COL44
        DBMS_RANDOM.STRING('U',40),  -- COL45
        DBMS_RANDOM.STRING('U',40),  -- COL46
        DBMS_RANDOM.STRING('U',40),  -- COL47
        DBMS_RANDOM.STRING('U',40),  -- COL48
        DBMS_RANDOM.STRING('U',40),  -- COL49
        DBMS_RANDOM.STRING('U',40),  -- COL50
        DBMS_RANDOM.STRING('U',40),  -- COL51
        DBMS_RANDOM.STRING('U',40),  -- COL52
        DBMS_RANDOM.STRING('U',40),  -- COL53
        DBMS_RANDOM.STRING('U',40),  -- COL54
        DBMS_RANDOM.STRING('U',40),  -- COL55
        DBMS_RANDOM.STRING('U',40),  -- COL56
        DBMS_RANDOM.STRING('U',40),  -- COL57
        DBMS_RANDOM.STRING('U',40),  -- COL58
        DBMS_RANDOM.STRING('U',40),  -- COL59
        DBMS_RANDOM.STRING('U',40),  -- COL60
        DBMS_RANDOM.STRING('U',40),  -- COL61
        DBMS_RANDOM.STRING('U',40),  -- COL62
        DBMS_RANDOM.STRING('U',40),  -- COL63
        DBMS_RANDOM.STRING('U',40),  -- COL64
        DBMS_RANDOM.STRING('U',40),  -- COL65
        DBMS_RANDOM.STRING('U',40),  -- COL66
        DBMS_RANDOM.STRING('U',40),  -- COL67
        DBMS_RANDOM.STRING('U',40),  -- COL68
        DBMS_RANDOM.STRING('U',40),  -- COL69
        DBMS_RANDOM.STRING('U',40),  -- COL70
        DBMS_RANDOM.STRING('U',40),  -- COL71
        DBMS_RANDOM.STRING('U',40),  -- COL72
        DBMS_RANDOM.STRING('U',40),  -- COL73
        DBMS_RANDOM.STRING('U',40),  -- COL74
        DBMS_RANDOM.STRING('U',40),  -- COL75
        DBMS_RANDOM.STRING('U',40),  -- COL76
        DBMS_RANDOM.STRING('U',40),  -- COL77
        DBMS_RANDOM.STRING('U',40),  -- COL78
        DBMS_RANDOM.STRING('U',40),  -- COL79
        DBMS_RANDOM.STRING('U',40),  -- COL80
        DBMS_RANDOM.STRING('U',40),  -- COL81
        DBMS_RANDOM.STRING('U',40),  -- COL82
        DBMS_RANDOM.STRING('U',40),  -- COL83
        DBMS_RANDOM.STRING('U',40),  -- COL84
        DBMS_RANDOM.STRING('U',40),  -- COL85
        DBMS_RANDOM.STRING('U',40),  -- COL86
        DBMS_RANDOM.STRING('U',40),  -- COL87
        DBMS_RANDOM.STRING('U',40),  -- COL88
        DBMS_RANDOM.STRING('U',40),  -- COL89
        DBMS_RANDOM.STRING('U',40),  -- COL90
        DBMS_RANDOM.STRING('U',40),  -- COL91
        DBMS_RANDOM.STRING('U',40),  -- COL92
        DBMS_RANDOM.STRING('U',40),  -- COL93
        DBMS_RANDOM.STRING('U',40),  -- COL94
        DBMS_RANDOM.STRING('U',40),  -- COL95
        DBMS_RANDOM.STRING('U',40),  -- COL96
        DBMS_RANDOM.STRING('U',40),  -- COL97
        DBMS_RANDOM.STRING('U',40),  -- COL98
        DBMS_RANDOM.STRING('U',40),  -- COL99
        DBMS_RANDOM.STRING('U',40)   -- COL100
      FROM dual;
    END LOOP;
  END IF;

  COMMIT;
END;
/
---------------------------------------------------------------
-- 3. Print row counts for SRC and TARGET tables
---------------------------------------------------------------
SET SERVEROUTPUT ON
DECLARE
  v_cnt_src NUMBER;
  v_cnt_tgt NUMBER;
BEGIN
  BEGIN
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM TABLE_CASE13_SRC'
      INTO v_cnt_src;
  EXCEPTION
    WHEN OTHERS THEN
      v_cnt_src := NULL;
  END;

  BEGIN
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM TABLE_CASE13_TARGET'
      INTO v_cnt_tgt;
  EXCEPTION
    WHEN OTHERS THEN
      v_cnt_tgt := NULL;
  END;

  DBMS_OUTPUT.PUT_LINE('TABLE_CASE13_SRC rows: ' ||
                       NVL(TO_CHAR(v_cnt_src),'N/A'));
  DBMS_OUTPUT.PUT_LINE('TABLE_CASE13_TARGET rows: ' ||
                       NVL(TO_CHAR(v_cnt_tgt),'N/A'));
END;
/
