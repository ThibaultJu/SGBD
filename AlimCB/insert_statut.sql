create or replace PROCEDURE INSERT_STATUT(p_id IN NUMBER, p_stat IN VARCHAR2) AS
  
v_stat   VARCHAR2(20 CHAR);

BEGIN
  IF (p_stat = NULL OR p_stat = 'Rumored' OR p_stat = 'Released' OR p_stat = 'Planned' OR p_stat = 'Canceled') THEN v_stat := p_stat;
  ELSE v_stat := NULL;
    PROC_LOG('insert_statut: ' || p_id || ' set à NULL');
  END IF;
  
  INSERT INTO STATUT VALUES(p_id, v_stat);

EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN PROC_LOG('insert_statut: SQLCODE : ' || SQLCODE || ' SQLERRM : ' || SQLERRM);
  WHEN OTHERS THEN PROC_LOG('insert_statut: ' || p_id || ' SQLCODE : ' || SQLCODE || ' SQLERRM : ' || SQLERRM);
END INSERT_STATUT;