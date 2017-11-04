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
               trim(film.tagline) || ' ' ||
               film.release_date || ' ' ||
               film.vote_average || ' ' ||
               trim(film.certification) || ' ' ||
               film.runtime || ' ' ||
               film.budget || ' ' ||
               film.poster_path || ' ' ||
               film.genres);
    i := 1;
    str1 := film.genres;
    
    loop
      str2 := regexp_substr(str1, '[^?]+', 1, i);
      dbms_output.put_line(str2);
      exit when str2 is null;

      found := owa_pattern.match(str2, '^(.*)?(.*)$', res);
      if found then
         dbms_output.put_line(res(1) || ' res 2 :' || res(2));
        insert_genre(res(1), res(2));
      end if;
      i := i +1;
    end loop;
    COMMIT;
    
    EXCEPTION
      WHEN OTHERS THEN PROC_LOG('get_movie: SQLCODE : ' || SQLCODE || ' SQLERRM : ' || SQLERRM);
END GET_MOVIE;