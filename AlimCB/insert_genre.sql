create or replace PROCEDURE INSERT_GENRE(p_id IN NUMBER, p_nomGenre IN VARCHAR2) AS

v_nomGenre  VARCHAR2(16 CHAR);
  
BEGIN
  v_nomGenre := p_nomGenre;
  
  INSERT INTO GENRE VALUES(p_id, v_nomGenre);

EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN PROC_LOG('insert_genre: SQLCODE : ' || SQLCODE || ' SQLERRM : ' || SQLERRM);
  WHEN OTHERS THEN PROC_LOG('insert_genre: ' || p_id || ' SQLCODE : ' || SQLCODE || ' SQLERRM : ' || SQLERRM);
END INSERT_GENRE;