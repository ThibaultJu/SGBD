create or replace PROCEDURE INSERT_ARTIST(p_id IN NUMBER, p_name IN VARCHAR2) AS

v_name VARCHAR2(50 CHAR);

BEGIN
  IF (LENGTH(p_name) <= 50) then v_name := p_name;
  ELSE IF (LENGTH(p_name) <= 283) then v_name := SUBSTR(p_name, 1, 50);
    PROC_LOG('insert_artist: ' || p_id || ' trunked ' || LENGTH(p_name) || ' => ' || LENGTH(v_name));
  END IF;
  END IF;

  INSERT INTO ARTIST VALUES(p_id, v_name);

EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN PROC_LOG('insert_artist: ' || p_id || ' SQLCODE : ' || SQLCODE || ' SQLERRM : ' || SQLERRM);
  WHEN OTHERS THEN PROC_LOG('insert_artist: ' || p_id || ' SQLCODE : ' || SQLCODE || ' SQLERRM : ' || SQLERRM);
END INSERT_ARTIST;