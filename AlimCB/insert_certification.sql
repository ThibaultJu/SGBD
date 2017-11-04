create or replace PROCEDURE INSERT_CERTIFICATION(p_id IN NUMBER, p_certif IN VARCHAR2) AS

v_certif VARCHAR2(5 CHAR);
  
BEGIN
  IF (p_certif = NULL OR p_certif = 'PG-13' OR p_certif = 'G' OR p_certif = 'PG' OR p_certif = 'R' OR p_certif = 'NC-17') THEN v_certif := p_certif;
  ELSE v_certif := NULL;
    PROC_LOG('insert_certification: ' || p_id || ' set à NULL');
  END IF;
  
  INSERT INTO CERTIFICATION VALUES(p_id, v_certif);

EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN PROC_LOG('insert_certification: SQLCODE : ' || SQLCODE || ' SQLERRM : ' || SQLERRM);
  WHEN OTHERS THEN PROC_LOG('insert_certification: ' || p_id || ' SQLCODE : ' || SQLCODE || ' SQLERRM : ' || SQLERRM);
END INSERT_CERTIFICATION;