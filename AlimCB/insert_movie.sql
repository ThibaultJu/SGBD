create or replace PROCEDURE INSERT_MOVIE
(
  p_id                IN NUMBER,
  p_title             IN VARCHAR2,
  p_statut            IN VARCHAR2,
  p_overview          IN VARCHAR2,
  p_release_date      IN DATE,
  p_vote_average      IN NUMBER,
  p_certif            IN VARCHAR2,
  p_runtime           IN NUMBER,
  p_budget            IN NUMBER,
  p_poster            IN VARCHAR2
)AS
  v_title             VARCHAR2(59 CHAR);
  v_statut            VARCHAR2(8 CHAR);
  v_overview          VARCHAR2(174 CHAR);
  v_release_date      DATE;
  v_vote_average      NUMBER;
  v_certif            VARCHAR2(5 CHAR);
  v_runtime           NUMBER;
  v_budget            NUMBER;
  v_poster            VARCHAR2(100 CHAR);
  
  post                BLOB;
  
  E_entite            EXCEPTION;
  PRAGMA              EXCEPTION_INIT(E_entite,-01);
  
BEGIN
  --title
  if (LENGTH(p_title) <= 59) 
    then v_title := p_title;
  else if (LENGTH(p_title) > 59)
    then v_title := SUBSTR(p_title, 1, 59);
    PROC_LOG('insert_movie: ' || p_id || ' title trunked ' || LENGTH(p_title) || ' => ' || LENGTH(v_title));
  end if;
  end if;

  --statut
  if (p_statut = NULL or p_statut = 'Post Production' or p_statut = 'Rumored' or p_statut = 'Released' or p_statut = 'In Production' or p_statut = 'Planned' or p_statut = 'Canceled') then v_statut := p_statut;
  else v_statut := null;
      PROC_LOG('insert_movie: ' || p_id || ' statut set à NULL');
  end if;
  
  --overview
  if (LENGTH(p_overview) <= 174 OR p_overview = NULL) 
    then v_overview := p_overview;
  else if (LENGTH(p_overview) > 174)
    then v_overview := SUBSTR(p_overview, 1, 174);
    PROC_LOG('insert_movie: ' || p_id || ' overview trunked ' || LENGTH(p_overview) || ' => ' || LENGTH(v_overview));
  end if;
  end if;
  
  --release_date
  v_release_date := p_release_date;

  --vote_average
  v_vote_average := p_vote_average;

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

  --budget
  if(p_budget >= 10499767) then v_budget := NULL;
      PROC_LOG('insert_movie: ' || p_id || ' budget set à NULL');
  else v_budget := p_budget;
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
  
  insert into movie values(p_id, v_title, v_statut, v_overview, v_release_date, v_vote_average, v_certif, v_runtime, v_budget, post);

EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN PROC_LOG('insert_movie: SQLCODE : ' || SQLCODE || ' SQLERRM : ' || SQLERRM);
  WHEN OTHERS THEN PROC_LOG('insert_movie: SQLCODE : ' || SQLCODE || ' SQLERRM : ' || SQLERRM);
END INSERT_MOVIE;