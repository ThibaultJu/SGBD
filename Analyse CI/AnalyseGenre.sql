create or replace procedure Analyse_Genre as
Begin
declare
   type EMP_DATA is record(
   max_GenreId number(9),
   min_GenreId number(9),
   count_GenreId number(9),
   max_LengthGenreName number(9),
   min_LengthGenreName number (9),
   Percentile_idName number (9),
   Avg_GenreName number (9),
   EcartType_GenreName number(9),
   Median_GenreName number(9));
   Type VAR_DATA is table of EMP_DATA;

  fid utl_file.file_type;
  V_DATA VAR_DATA;
Begin
 fid := utl_file.fopen ('MYDIR', 'Genre.txt', 'W');

WITH temp (s, id, i, n) as (
  select genres, null, 1, 1 from movies_ext 
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

SELECT max(id) max_GenreId ,
        min(id) min_GenreId,
        count(id) count_GenreId,
        max(length(Name)) max_LengthGenreName,
        min(length(Name)) min_LengthGenreName,
        percentile_cont(0.95) within group (order by length(Name)) Percentile_idName,
        round(avg(length(Name)),0) Avg_GenreName,
        round(STDDEV(length(Name)),0) EcartType_GenreName,
        median(length(Name)) Median_GenreName
        bulk collect into V_DATA
FROM sub;

    utl_file.put_line (fid,'max_GenreId: ' || V_DATA(1).max_GenreId);
    utl_file.put_line(fid,'min_GenreId: ' ||V_DATA(1).min_GenreId);
    utl_file.put_line (fid,'max_LengthGenreName: ' || V_DATA(1).max_LengthGenreName);
    utl_file.put_line (fid,'min_LengthGenreName: ' ||V_DATA(1).min_LengthGenreName);
    utl_file.put_line (fid,'Percentile_idName: ' || V_DATA(1).Percentile_idName);
    utl_file.put_line (fid,'Avg_GenreName: ' || V_DATA(1).Avg_GenreName );
    utl_file.put_line (fid,'EcartType_GenreName: ' || V_DATA(1).EcartType_GenreName);
    utl_file.put_line (fid,'Median_GenreName: ' || V_DATA(1).Median_GenreName);
    utl_file.fclose (fid);
exception when others then
  if utl_file.is_open(fid) then
    utl_file.fclose (fid);
  end if;
    dbms_output.put_line('SQLCODE : ' || SQLCODE || 'SQLERRM : ' || SQLERRM);
end;
end Analyse_Genre;