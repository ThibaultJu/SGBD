create or replace procedure ALIM_GENRE as
Begin

declare
   type EMP_DATA is record(
    Nbr  number(9),
    str  VARCHAR2(16 CHAR));
   Type VAR_DATA is table of EMP_DATA;

  fid utl_file.file_type;
  V_DATA VAR_DATA;
  
Begin  
WITH temp (s, id, i, n) as (
  select genres, null, 1, 1 from movies_ext where id = 27205
  union all
  select coalesce(substr(s, instr(s, unistr('\2016'))+1), '0'),
        DECODE(substr(s, 1, instr(s, unistr('\2016'))-1),NULL ,s ,substr(s, 1, instr(s, unistr('\2016'))-1)),
         instr(s, unistr('\2016')), i 
  from temp 
  WHERE i> 0 AND  s != '0'
),
sub(id, Name) as (
    select CAST(substr(id, 1 ,instr(id, unistr('\2024'))-1 ) AS NUMBER) as identifiant,
    substr(id,instr(id, unistr('\2024'))+1) as genres from temp where id is not null
)

SELECT id,
        Name
        bulk collect into V_DATA
FROM sub;
   FOR indx IN 1 .. V_DATA.COUNT 
   LOOP    
       insert_genre(V_DATA(indx).Nbr, V_DATA(indx).str);
   END LOOP;
end;
end ALIM_GENRE;