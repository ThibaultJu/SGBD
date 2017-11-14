create or replace PROCEDURE INSERT_GENRE(p_id IN NUMBER, p_nomGenre IN VARCHAR2) AS

v_nomGenre  VARCHAR2(16 CHAR);
c_nomGenre VARCHAR2(200 CHAR);
  
BEGIN
 c_nomGenre := replace(p_nomGenre,unistr('\0027') , '');
 IF (LENGTH(c_nomGenre) <= 16) then v_nomGenre := c_nomGenre;
  ELSE IF (LENGTH(c_nomGenre) > 16) then v_nomGenre := SUBSTR(c_nomGenre, 1, 16);
    PROC_LOG('insert_genre: ' || p_id || ' trunked ' || LENGTH(c_nomGenre) || ' => ' || LENGTH(v_nomGenre));
  END IF;
  END IF;
  
  INSERT INTO GENRE VALUES(p_id, v_nomGenre);

EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN PROC_LOG('insert_genre: SQLCODE : ' || SQLCODE || ' SQLERRM : ' || SQLERRM);
  WHEN OTHERS THEN PROC_LOG('insert_genre: ' || p_id || ' SQLCODE : ' || SQLCODE || ' SQLERRM : ' || SQLERRM);
END INSERT_GENRE;