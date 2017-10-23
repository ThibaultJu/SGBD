create or replace procedure Analyse_Certification as
Begin
declare
   type EMP_DATA is record(
   DistinctCertification varchar(50),
   countCertification number(9)
   );
   
   Type VAR_DATA is table of EMP_DATA;

  fid utl_file.file_type;
  V_DATA VAR_DATA;
Begin
 fid := utl_file.fopen ('MYDIR', 'Certification.txt', 'a');


select distinct certification,
        count(certification)
        bulk collect into V_DATA
from movies_ext
group by certification;

   FOR indx IN 1 .. V_DATA.COUNT 
   LOOP    
       utl_file.put_line (fid,'DistinctCertification: ' || V_DATA(indx).DistinctCertification);
       utl_file.put_line (fid,'countCertification: ' || V_DATA(indx).countCertification);
       utl_file.put_line (fid,' ');
   END LOOP;


    utl_file.fclose (fid);

exception when others then
  if utl_file.is_open(fid) then
    utl_file.fclose (fid);
  end if;
    dbms_output.put_line('SQLCODE : ' || SQLCODE || 'SQLERRM : ' || SQLERRM);
end;
end Analyse_Certification;