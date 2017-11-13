create or replace PROCEDURE GET_MOVIE(p_id IN NUMBER) AS

i integer := 1;
res owa_text.vc_arr;
found boolean;

film movies_ext%ROWTYPE;

str1 VARCHAR(30000);
str2 VARCHAR(30000);

BEGIN
  SELECT * INTO film FROM movies_ext WHERE id=p_id; --27205 pour Inception
  dbms_output.put_line(film.id || ' ' ||
               trim(film.title) || ' ' || 
               trim(film.status) || ' ' ||
               film.release_date || ' ' ||
               film.vote_average || ' ' ||
               trim(film.certification) || ' ' ||
               film.runtime || ' ' ||
               film.poster_path || ' ' ||
               film.genres);

    insert_movie(film.id, 
               trim(film.title), 
               trim(film.status),  
               film.release_date, 
               round(film.vote_average,1),
               film.vote_count,
               trim(film.certification), 
               film.runtime,  
               film.poster_path);
    i := 1;
    str1 := film.actors;
    loop
      str2 := regexp_substr(str1, '(.*?)(' || unistr('\2016') || '|$)', 1, i, '', 1);
      exit when str2 is null;

      found := owa_pattern.match(str2, '^(.*)' || unistr('\2024') || '(.*)' || unistr('\2024') || '(.*)$', res);
      if found then
        insert_artist(res(1), res(2));
        insert_movie_actor(film.id, res(1));
      end if;
      i := i +1;
    end loop;


    i := 1;
    str1 := film.directors;
    loop
      str2 := regexp_substr(str1, '(.*?)(' || unistr('\2016') || '|$)', 1, i, '', 1);
      exit when str2 is null;

      found := owa_pattern.match(str2, '^(.*)' || unistr('\2024') || '(.*)$', res);
      if found then
        insert_director(res(1), res(2));
        insert_movie_director(film.id, res(1));
      end if;
      i := i +1;
    end loop;
    i := 1;
    str1 := film.genres;

    loop
      str2 := regexp_substr(str1, '(.*?)(' || unistr('\2016') || '|$)', 1, i, '', 1);
      exit when str2 is null;

      found := owa_pattern.match(str2, '^(.*)' || unistr('\2024') || '(.*)$', res);

      if found then
        insert_genre(res(1), res(2));
         insert_movie_genre(film.id, res(1));
      end if;
      i := i +1;
    end loop;
    
    insert_certification(film.id, trim(film.certification));
    insert_status(film.id, trim(film.status));
    COMMIT;

    EXCEPTION
      WHEN OTHERS THEN PROC_LOG('get_movie: SQLCODE : ' || SQLCODE || ' SQLERRM : ' || SQLERRM);
END GET_MOVIE;