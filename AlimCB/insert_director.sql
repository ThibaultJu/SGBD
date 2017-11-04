create or replace PROCEDURE INSERT_DIRECTOR(p_id IN NUMBER, p_name IN VARCHAR2) AS

v_name    VARCHAR2(49 CHAR);

BEGIN
  v_name := p_name;

  INSERT INTO DIRECTOR VALUES(p_id, v_name);

EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN PROC_LOG('insert_director: SQLCODE : ' || SQLCODE || ' SQLERRM : ' || SQLERRM);
  WHEN OTHERS THEN PROC_LOG('insert_director: ' || p_id || ' SQLCODE : ' || SQLCODE || ' SQLERRM : ' || SQLERRM);
END INSERT_DIRECTOR;