create or replace PROCEDURE GET_MOVIES_RANDOM(p_nbr IN NUMBER) AS

i integer := 1;
j NUMBER := 0;
res owa_text.vc_arr;
found boolean;

CURSOR c_film IS
SELECT * FROM (SELECT * FROM movies_ext ORDER BY DBMS_RANDOM.VALUE) WHERE rownum < p_nbr+1;
film movies_ext%ROWTYPE;

str1 VARCHAR(30000);
str2 VARCHAR(30000);

BEGIN
  OPEN c_film;
  FETCH c_film INTO film;
  WHILE c_film%FOUND AND j < p_nbr LOOP
    BEGIN
      dbms_output.put_line(j+1 || '- ' ||
                           film.id || ' ' ||
                           trim(film.title) || ' ' || 
                           trim(film.status) || ' ' ||
                           trim(film.tagline) || ' ' ||
                           film.release_date || ' ' ||
                           film.vote_average || ' ' ||
                           trim(film.certification) || ' ' ||
                           film.runtime || ' ' ||
                           film.budget || ' ' ||
                           film.poster_path);

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
        --insert_movie_artist(film.id, res(1));
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
        --insert_movie_director(film.id, res(1));
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
      WHEN OTHERS THEN PROC_LOG('get_movies_random: SQLCODE : ' || SQLCODE || ' SQLERRM : ' || SQLERRM);
  END;
  j := j + 1;
  FETCH c_film INTO film;
  END LOOP;
END GET_MOVIES_RANDOM;