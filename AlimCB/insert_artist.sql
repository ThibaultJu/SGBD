create or replace PROCEDURE INSERT_ARTIST(p_id IN NUMBER, p_name IN VARCHAR2) AS

v_name VARCHAR2(20 CHAR);
c_name VARCHAR2(200 CHAR);

BEGIN
 c_name := replace(p_name,unistr('\0027') , '');
  IF (LENGTH(c_name) <= 20) then v_name := c_name;
  ELSE v_name := SUBSTR(c_name, 1, 20);
    PROC_LOG('insert_artist: ' || p_id || ' trunked ' || LENGTH(c_name) || ' => ' || LENGTH(v_name));
  END IF;

  INSERT INTO ARTIST VALUES(p_id, v_name);

EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN PROC_LOG('insert_artist: ' || p_id || ' SQLCODE : ' || SQLCODE || ' SQLERRM : ' || SQLERRM);
  WHEN OTHERS THEN PROC_LOG('insert_artist: ' || p_id || ' SQLCODE : ' || SQLCODE || ' SQLERRM : ' || SQLERRM);
END INSERT_ARTIST;