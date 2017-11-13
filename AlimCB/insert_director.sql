create or replace PROCEDURE INSERT_DIRECTOR(p_id IN NUMBER, p_name IN VARCHAR2) AS

v_name    VARCHAR2(19 CHAR);

BEGIN
  v_name := p_name;
  
  
  IF (LENGTH(p_name) <= 19) then v_name := p_name;
  ELSE IF (LENGTH(p_name) > 19) then v_name := SUBSTR(p_name, 1, 19);
    PROC_LOG('insert_director: ' || p_id || ' trunked ' || LENGTH(p_name) || ' => ' || LENGTH(v_name));
  END IF;
  END IF;
  
  INSERT INTO DIRECTOR VALUES(p_id, v_name);

EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN PROC_LOG('insert_director: SQLCODE : ' || SQLCODE || ' SQLERRM : ' || SQLERRM);
  WHEN OTHERS THEN PROC_LOG('insert_director: ' || p_id || ' SQLCODE : ' || SQLCODE || ' SQLERRM : ' || SQLERRM);
END INSERT_DIRECTOR;