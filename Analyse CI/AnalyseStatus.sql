create or replace procedure Analyse_Status as
Begin
declare
   type EMP_DATA is record(
   DistinctStatus varchar(50),
   countStatus number(9)
   );
   Type VAR_DATA is table of EMP_DATA;

  fid utl_file.file_type;
  V_DATA VAR_DATA;
Begin
 fid := utl_file.fopen ('MYDIR', 'Status.txt', 'a');
 
select distinct status,
        count(status) 
        bulk collect into V_DATA
from movies_ext
group by status;

   FOR indx IN 1 .. V_DATA.COUNT 
   LOOP
   utl_file.put_line (fid,' ');
       utl_file.put_line (fid,'DistinctStatus: ' || V_DATA(indx).DistinctStatus);
       utl_file.put_line (fid,'countStatus: ' || V_DATA(indx).countStatus);
   END LOOP;
    

    utl_file.fclose (fid);
    
exception when others then
  if utl_file.is_open(fid) then
    utl_file.fclose (fid);
  end if;
    dbms_output.put_line('SQLCODE : ' || SQLCODE || 'SQLERRM : ' || SQLERRM);
end;
end Analyse_Status;