create or replace PROCEDURE INSERT_MOVIE
(
  p_id                IN NUMBER,
  p_title             IN VARCHAR2,
  p_status            IN VARCHAR2,
  p_release_date      IN DATE,
  p_vote_average      IN NUMBER,
  p_vote_count      IN NUMBER,
  p_certif            IN VARCHAR2,
  p_runtime           IN NUMBER,
  p_poster            IN VARCHAR2
)AS
  v_id                NUMBER;
  v_title             VARCHAR2(43 CHAR);
  c_title             VARCHAR2(200 CHAR);
  v_status            VARCHAR2(15 CHAR);
  v_release_date      DATE;
  v_vote_average      NUMBER;
  v_vote_count        NUMBER;
  v_certif            VARCHAR2(5 CHAR);
  v_runtime           NUMBER;
  v_poster            VARCHAR2(100 CHAR);

  post                BLOB;

  E_entite            EXCEPTION;
  PRAGMA              EXCEPTION_INIT(E_entite,-01);

BEGIN
  dbms_output.put_line(v_id || ' ' ||
               v_title || ' ' || 
               v_status  || ' ' ||
               v_release_date || ' ' ||
               v_vote_average || ' ' ||
               v_vote_count || ' ' ||
               v_certif || ' ' ||
               v_runtime || ' ' ||
               v_poster);
  --title
  c_title := replace(p_title,unistr('\0027') , '');
  if (LENGTH(c_title) <= 43) 
    then v_title := c_title;
  else if (LENGTH(c_title) > 43)
    then v_title := SUBSTR(c_title, 1, 43);
    PROC_LOG('insert_movie: ' || p_id || ' title trunked ' || LENGTH(c_title) || ' => ' || LENGTH(v_title));
  end if;
  end if;
  --status
  if (p_status = NULL or p_status = 'Post Production' or p_status = 'Rumored' or p_status = 'Released' or p_status = 'In Production' or p_status = 'Planned' or p_status = 'Canceled') then v_status := p_status;
  else v_status := null;
      PROC_LOG('insert_movie: ' || p_id || ' status set à  NULL');
  end if;
  --release_date
  v_release_date := p_release_date;
  --vote_average
  IF(p_vote_average>=0 AND p_vote_average<=10)
  THEN v_vote_average := p_vote_average;
  else v_vote_average := 0;
  PROC_LOG('insert_movie: vote avg set à 0');
  END IF;
  --vote_count
  IF(p_vote_count>=0)
  THEN v_vote_count := p_vote_count;
  else v_vote_count := 0;
  PROC_LOG('insert_movie: vote_count set à 0');
  end if;
  --certification
  IF (p_certif = NULL OR p_certif = 'PG-13' OR p_certif = 'G' OR p_certif = 'PG' OR p_certif = 'R' OR p_certif = 'NC-17') THEN v_certif := p_certif;
  ELSE v_certif := NULL;
    PROC_LOG('insert_movie: ' || p_id || ' certification set à  NULL');
  END IF;
  --runtime
  if(p_runtime > 135) then v_runtime := 135;
      PROC_LOG('insert_movie: ' || p_id || ' runtime set a Val max acceptée');
  else v_runtime := p_runtime;
  end if;
  --poster
  BEGIN
  IF p_poster IS NOT NULL THEN
    v_poster := 'http://image.tmdb.org/t/p/w185' || p_poster;
    post := HTTPURITYPE.CREATEURI(v_poster).getblob();
    dbms_output.put_line('BLOB : OK ');
  END IF;
  EXCEPTION WHEN OTHERS THEN 
   post:=NULL; 
   PROC_LOG('BLOB:' || 'Une erreur est survenue le blob est donc mis Ã  NULL');
  END;
  insert into movie values(p_id, v_title, v_status, v_release_date, v_vote_average,v_vote_count, v_certif, v_runtime, post);
dbms_output.put_line('INSERT DE ' || v_title || 'OK');
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN PROC_LOG('insert_movie: SQLCODE : ' || SQLCODE || ' SQLERRM : ' || SQLERRM);
  WHEN OTHERS THEN PROC_LOG('insert_movie: SQLCODE : ' || SQLCODE || ' SQLERRM : ' || SQLERRM);
END INSERT_MOVIE;