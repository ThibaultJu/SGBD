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
  v_title             VARCHAR2(59 CHAR);
  v_status            VARCHAR2(8 CHAR);
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
  if (LENGTH(p_title) <= 59) 
    then v_title := p_title;
  else if (LENGTH(p_title) > 59)
    then v_title := SUBSTR(p_title, 1, 59);
    PROC_LOG('insert_movie: ' || p_id || ' title trunked ' || LENGTH(p_title) || ' => ' || LENGTH(v_title));
  end if;
  end if;
  --status
  if (p_status = NULL or p_status = 'Post Production' or p_status = 'Rumored' or p_status = 'Released' or p_status = 'In Production' or p_status = 'Planned' or p_status = 'Canceled') then v_status := p_status;
  else v_status := null;
      PROC_LOG('insert_movie: ' || p_id || ' statut set à NULL');
  end if;
  --release_date
  v_release_date := p_release_date;
  --vote_average
  v_vote_average := p_vote_average;
  --vote_count
  v_vote_count   := p_vote_count;
  --certification
  IF (p_certif = NULL OR p_certif = 'PG-13' OR p_certif = 'G' OR p_certif = 'PG' OR p_certif = 'R' OR p_certif = 'NC-17') THEN v_certif := p_certif;
  ELSE v_certif := NULL;
    PROC_LOG('insert_certification: ' || p_id || ' set à NULL');
  END IF;
  --runtime
  if(p_runtime > 200) then v_runtime := NULL;
      PROC_LOG('insert_movie: ' || p_id || ' runtime set à NULL');
  else v_runtime := p_runtime;
  end if;
  --poster
  BEGIN
  IF p_poster IS NOT NULL THEN
    v_poster := 'http://image.tmdb.org/t/p/w185' || p_poster;
    post := HTTPURITYPE.CREATEURI(v_poster).getblob();
  END IF;
  EXCEPTION WHEN OTHERS THEN 
   post:=NULL; 
   PROC_LOG('BLOB:' || 'Une erreur est survenue le blob est donc mis à NULL');
  END;
  insert into movie values(p_id, v_title, v_status, v_release_date, v_vote_average,v_vote_count, v_certif, v_runtime, post);
dbms_output.put_line('INSERT OK' );
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN PROC_LOG('insert_movie: SQLCODE : ' || SQLCODE || ' SQLERRM : ' || SQLERRM);
  WHEN OTHERS THEN PROC_LOG('insert_movie: SQLCODE : ' || SQLCODE || ' SQLERRM : ' || SQLERRM);
END INSERT_MOVIE;