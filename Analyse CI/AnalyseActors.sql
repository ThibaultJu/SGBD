create or replace procedure Analyse_Actors as
Begin
declare
   type EMP_DATA is record(
   max_ActorsId number(9),
   min_ActorsId number(9),
   count_ActorsId number(9),
   max_LengthActorsName number(9),
   min_LengthActorsName number (9),
   Percentile_idName number (9),
   Avg_ActorsName number (9),
   EcartType_ActorsName number(9),
   Median_ActorsName number(9));
   Type VAR_DATA is table of EMP_DATA;

  fid utl_file.file_type;
  V_DATA VAR_DATA;
Begin
 fid := utl_file.fopen ('b_file', 'Actors.txt', 'W');

WITH temp (s, id, i, n) as (
  select Actors, null, 1, 1 from movies_ext WHERE rownum <= 10000
  union all
  select coalesce(substr(s, instr(s, unistr('\2016'))+1), '0'),
        DECODE(substr(s, 1, instr(s, unistr('\2016'))-1),NULL ,s ,substr(s, 1, instr(s, unistr('\2016'))-1)),
         instr(s, unistr('\2016')), i 
  from temp 
  WHERE i> 0 AND  s != '0'
),
sub(id, Name) as (
    select CAST(substr(id, 1 ,instr(id, unistr('\2024'))-1 ) AS NUMBER) as identifiant,
    substr(id,instr(id, unistr('\2024'))+1) as Actors from temp where id is not null
)

SELECT max(id) max_ActorsId ,
        min(id) min_ActorsId,
        count(id) count_ActorsId,
        max(length(Name)) max_LengthActorsName,
        min(length(Name)) min_LengthActorsName,
        percentile_cont(0.95) within group (order by length(Name)) Percentile_idName,
        round(avg(length(Name)),0) Avg_ActorsName,
        round(STDDEV(length(Name)),0) EcartType_ActorsName,
        median(length(Name)) Median_ActorsName
        bulk collect into V_DATA
FROM sub;

    utl_file.put_line (fid,'max_ActorsId: ' || V_DATA(1).max_ActorsId);
    utl_file.put_line(fid,'min_ActorsId: ' ||V_DATA(1).min_ActorsId);
    utl_file.put_line (fid,'max_LengthActorsName: ' || V_DATA(1).max_LengthActorsName);
    utl_file.put_line (fid,'min_LengthGenreName: ' ||V_DATA(1).min_LengthActorsName);
    utl_file.put_line (fid,'Percentile_idName: ' || V_DATA(1).Percentile_idName);
    utl_file.put_line (fid,'Avg_ActorsName: ' || V_DATA(1).Avg_ActorsName );
    utl_file.put_line (fid,'EcartType_ActorsName: ' || V_DATA(1).EcartType_ActorsName);
    utl_file.put_line (fid,'Median_ActorsName: ' || V_DATA(1).Median_ActorsName);
    utl_file.fclose (fid);
exception when others then
  if utl_file.is_open(fid) then
    utl_file.fclose (fid);
  end if;
    dbms_output.put_line('SQLCODE : ' || SQLCODE || 'SQLERRM : ' || SQLERRM);
end;
end Analyse_Actors;