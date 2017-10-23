create or replace procedure Analyse_Directors as
Begin
declare
   type EMP_DATA is record(
   max_DirectorsId number(9),
   min_DirectorsId number(9),
   count_DirectorsId number(9),
   max_LengthDirectorsName number(9),
   min_LengthDirectorsName number (9),
   Percentile_idNameDirectors number (9),
   Avg_DirectorsName number (9),
   EcartType_DirectorsName number(9),
   Median_DirectorsName number(9));
   Type VAR_DATA is table of EMP_DATA;

  fid utl_file.file_type;
  V_DATA VAR_DATA;
Begin
 fid := utl_file.fopen ('MYDIR', 'Directors.txt', 'W');

WITH temp (s, id, i, n) as (
  select directors, null, 1, 1 from movies_ext 
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

SELECT max(id) max_DirectorsId,
    min(id)min_DirectorsId,
    count(id) count_DirectorsId,
    max(length(Name)) max_LengthDirectorsName,
    min(length(Name)) min_LengthDirectorsName,
    percentile_cont(0.95) within group (order by length(Name)) Percentile_idNameDirectors,
    round(avg(length(Name)),0) Avg_DirectorsName,
    round(STDDEV(length(Name)),0) EcartType_DirectorsName,
    median(length(Name)) Median_DirectorsName
    bulk collect into V_DATA
FROM sub;

    utl_file.put_line (fid,'max_DirectorsId: ' || V_DATA(1).max_DirectorsId);
    utl_file.put_line(fid,'count_DirectorsId: ' ||V_DATA(1).count_DirectorsId);
    utl_file.put_line (fid,'max_LengthDirectorsName: ' || V_DATA(1).max_LengthDirectorsName);
    utl_file.put_line (fid,'min_LengthDirectorsName: ' ||V_DATA(1).min_LengthDirectorsName);
    utl_file.put_line (fid,'Percentile_idNameDirectors: ' || V_DATA(1).Percentile_idNameDirectors);
    utl_file.put_line (fid,'Avg_DirectorsName: ' || V_DATA(1).Avg_DirectorsName );
    utl_file.put_line (fid,'EcartType_DirectorsName: ' || V_DATA(1).EcartType_DirectorsName);
    utl_file.put_line (fid,'Median_DirectorsName: ' || V_DATA(1).Median_DirectorsName);
    utl_file.fclose (fid);
exception when others then
  if utl_file.is_open(fid) then
    utl_file.fclose (fid);
  end if;
    dbms_output.put_line('SQLCODE : ' || SQLCODE || 'SQLERRM : ' || SQLERRM);
end;
end Analyse_Directors;