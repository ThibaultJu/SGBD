create or replace procedure Analyse_IdTitleVoteRunTime as
Begin
declare
   type EMP_DATA is record(
   Max_ID number(9),
   Min_id number(9),
   count_Id number(9),
   null_id number(9),
   
   max_TITLE NUMBER(9),
   MIN_TITLE NUMBER(9),
   Percentile_Title NUMBER(9),
   AVG_TITLE NUMBER(9),
   ECARTTYPE_TITLE NUMBER(9),
   MEDIAN_TITLE NUMBER(9),
   
   DATE_MAX NUMBER(9),
   DATE_MIN NUMBER(9),
   DATE_NBRE NUMBER(9),
   NULL_RELEADE_DATE NUMBER(9),
   
   NBRESTATUS NUMBER(9),
   MaxTailleStatus NUMBER(9),
   MinTailleStatus NUMBER(9),
   Percentile_Status NUMBER(9),
   
   NBRECertification NUMBER(9),
   MaxTailleCertification NUMBER(9),
   MinTailleCertification NUMBER(9),
   Percentile_Certification NUMBER(9),
   
   MAX_VOTE_AVG NUMBER(9),
   MIN_VOTE_AVG NUMBER (9),
   NULL_VOTE_AVG NUMBER(9),
   VOTE_AVG_EXIST NUMBER(9),
   AVG_VOTE NUMBER(5,3),
   ECARTTYPE_AVG_VOTE NUMBER(5,3),
   Median_Avg_Vote NUMBER(9),
   
   MAX_VOTE_COUNT NUMBER(9),
   MIN_VOTE_COUNT NUMBER(9),
   NULL_VOTE_COUNT NUMBER (9),
   VOTE_COUNT_EXIST NUMBER (9),
   AVG_VOTE_COUNT NUMBER(5,3),
   ECARTTYPE_VOTE_COUNT NUMBER (5,3),
   MEDIAN_VOTE_COUNT NUMBER(5),
   
   MAX_RUNTIME NUMBER(9),
   MIN_RUNTIME NUMBER(9),
   NULL_RUNTIME NUMBER (9),
   RUNTIME_NNULL NUMBER (9),
   AVG_RUNTIME NUMBER (5,3),
   ECARTTYPE_RUNTIME NUMBER (5,3),
   MEDIAN_RUNTIME NUMBER(9),
   PERCENTILE_RUNTIME NUMBER (9)
   );
   Type VAR_DATA is table of EMP_DATA;

  fid utl_file.file_type;
  fidT utl_file.file_type;
  fidS utl_file.file_type;
  fidVAVG utl_file.file_type;
  fidVC utl_file.file_type;
  fidRT utl_file.file_type;
  V_DATA VAR_DATA;
Begin
 fid := utl_file.fopen ('MYDIR', 'Id.txt', 'W');
 fidT := utl_file.fopen ('MYDIR', 'Title.txt', 'W');
 fidC := utl_file.fopen ('MYDIR', 'Certification.txt', 'W');
 fidS := utl_file.fopen ('MYDIR', 'Status.txt', 'W');
 fidVAVG := utl_file.fopen ('MYDIR', 'VoteAVG.txt', 'W');
 fidVC := utl_file.fopen ('MYDIR', 'VoteCount.txt', 'W');
 fidRT := utl_file.fopen ('MYDIR', 'Runtime.txt', 'W');
 
select  max(id) Max_ID,
        min(id) Min_id,
        count(id) count_Id,
        Sum(
            case coalesce(id,0)
                when id then 0
                else 1
            end
        ) Null_id,
        
        max(length(title)) Max_Title,
        min(length(title)) Min_Title,
        percentile_cont(0.95) within group (order by length(title)) Percentile_Title,
        round(avg(length(title)),0) Avg_Title,
        round(STDDEV(length(title)),0) EcartType_Title,
        median(length(title)) Median_Title,
        
        max(extract(YEAR from release_date)) Date_MAX,
        min(extract(YEAR from release_date)) Date_Min,
        count(release_date) Date_Nbre,
        Sum(
            case release_date
                when release_date then 0
                else 1
            end
        ) Null_release_date,
        
        count(distinct status) Nbrstatus, 
        max(length(status)) MaxTailleStatus,
        min(length(status)) MinTailleStatus,
        percentile_cont(0.95) within group (order by length(status)) Percentile_Status,
        
        count(distinct certification) Nbrcertification, 
        max(length(certification)) MaxTaillecertification,
        min(length(certification)) MinTaillecertification,
        percentile_cont(0.95) within group (order by length(certification)) Percentile_certification,
        
        max(vote_average) MAX_VOTE_AVG,
        min(vote_average) MIN_VOTE_AVG,
        Sum(
            case  when (vote_average = 0) then 1
                else 0
            end
        ) NULL_VOTE_AVG,
        Sum(
            case  when (vote_average = 0) then 0
                else 1
            end
        ) VOTE_AVG_EXIST,
        round(avg(length(vote_average)),2) Avg_Vote,
        round(STDDEV(length(vote_average)),2) EcartType_Avg_Vote,
        median(vote_average) Median_Avg_Vote,
        
        max(vote_count) MAX_VOTE_COUNT,
        min(vote_count) MIN_VOTE_COUNT,
        Sum(
            case  when (vote_count = 0) then 1
                else 0
            end
        ) NULL_vote_count,
        Sum(
            case  when (vote_count = 0) then 0
                else 1
            end
        ) vote_count_Exist,
        round(avg(length(vote_count)),2) AVG_vote_count,
        round(STDDEV(length(vote_count)),2) EcartType_vote_count,
        median(vote_count) Median_vote_count,
        max(runtime) MAX_RUNTIME,
        min(runtime) MIN_RUNTIME,
        Sum(
            case  when (runtime = 0) then 1
                else 0
            end
        ) NULL_runtime,
        Sum(
            case  when (runtime = 0) then 0
                else 1
            end
        ) runtime_NNULL,
        round(avg(length(runtime)),2) Avg_runtime,
        round(STDDEV(length(runtime)),2) EcartType_runtime,
        median(runtime) Median_runtime,
        percentile_cont(0.95) within group (order by runtime) Percentile_runtime
        bulk collect into V_DATA
from movies_ext;
    utl_file.put_line (fid,'Max_ID: ' || V_DATA(1).Max_ID);
    utl_file.put_line(fid,'Min_id: ' ||V_DATA(1).Min_id);
    utl_file.put_line (fid,'count_Id: ' || V_DATA(1).count_Id);
    utl_file.put_line (fid,'null_id: ' ||V_DATA(1).null_id);
    utl_file.fclose (fid);
    
    utl_file.put_line (fidT,'max_TITLE: ' || V_DATA(1).max_TITLE);
    utl_file.put_line (fidT,'MIN_TITLE: ' || V_DATA(1).MIN_TITLE );
    utl_file.put_line (fidT,'AVG_TITLE: ' || V_DATA(1).AVG_TITLE);
    utl_file.put_line (fidT,'Percentile_Title: ' || V_DATA(1).Percentile_Title);
    utl_file.put_line (fidT,'ECARTTYPE_TITLE: ' || V_DATA(1).ECARTTYPE_TITLE);
    utl_file.put_line (fidT,'MEDIAN_TITLE: ' || V_DATA(1).MEDIAN_TITLE);
    utl_file.fclose (fidT);
    
    utl_file.put_line (fidS,'NBRESTATUS: ' || V_DATA(1).NBRESTATUS);
    utl_file.put_line (fidS,'MaxTailleStatus: ' || V_DATA(1).MaxTailleStatus);
    utl_file.put_line (fidS,'MinTailleStatus: ' || V_DATA(1).MinTailleStatus);
    utl_file.put_line (fidS,'Percentile_Status: ' || V_DATA(1).Percentile_Status);
    utl_file.fclose (fidS);
    
    utl_file.put_line (fidC,'NBRECertification: ' || V_DATA(1).NBRECertification);
    utl_file.put_line (fidC,'MaxTailleCertification: ' || V_DATA(1).MaxTailleCertification);
    utl_file.put_line (fidC,'MinTailleCertification: ' || V_DATA(1).MinTailleCertification);
    utl_file.put_line (fidC,'Percentile_Certification: ' || V_DATA(1).Percentile_Certification);
    utl_file.fclose (fidC);
    
    utl_file.put_line (fidVAVG,'MAX_VOTE_AVG: ' || V_DATA(1).MAX_VOTE_AVG);
    utl_file.put_line (fidVAVG,'MIN_VOTE_AVG: ' || V_DATA(1).MIN_VOTE_AVG );
    utl_file.put_line (fidVAVG,'NULL_VOTE_AVG: ' || V_DATA(1).NULL_VOTE_AVG);
    utl_file.put_line (fidVAVG,'VOTE_AVG_EXIST: ' || V_DATA(1).VOTE_AVG_EXIST);
    utl_file.put_line (fidVAVG,'AVG_VOTE: ' || V_DATA(1).AVG_VOTE);
    utl_file.put_line (fidVAVG,'ECARTTYPE_AVG_VOTE: ' || V_DATA(1).ECARTTYPE_AVG_VOTE);
    utl_file.put_line (fidVAVG,'Median_Avg_Vote: ' || V_DATA(1).Median_Avg_Vote);
    utl_file.fclose (fidVAVG);
    
    utl_file.put_line (fidVC,'MAX_VOTE_COUNT: ' || V_DATA(1).MAX_VOTE_COUNT );
    utl_file.put_line (fidVC,'MIN_VOTE_COUNT: ' || V_DATA(1).MIN_VOTE_COUNT);
    utl_file.put_line (fidVC,'NULL_VOTE_COUNT: ' || V_DATA(1).NULL_VOTE_COUNT);
    utl_file.put_line (fidVC,'VOTE_COUNT_EXIST: ' || V_DATA(1).VOTE_COUNT_EXIST);
    utl_file.put_line (fidVC,'AVG_VOTE_COUNT: ' || V_DATA(1).AVG_VOTE_COUNT);
    utl_file.put_line (fidVC,'ECARTTYPE_VOTE_COUNT: ' || V_DATA(1).ECARTTYPE_VOTE_COUNT );
    utl_file.put_line (fidVC,'MEDIAN_VOTE_COUNT: ' || V_DATA(1).MEDIAN_VOTE_COUNT);
    utl_file.fclose (fidVC);
    
    utl_file.put_line (fidRT,'MAX_RUNTIME: ' || V_DATA(1).MAX_RUNTIME);
    utl_file.put_line (fidRT,'MIN_RUNTIME: ' || V_DATA(1).MIN_RUNTIME);
    utl_file.put_line (fidRT,'NULL_RUNTIME: ' || V_DATA(1).NULL_RUNTIME);
    utl_file.put_line (fidRT,'RUNTIME_NNULL: ' || V_DATA(1).RUNTIME_NNULL);
    utl_file.put_line (fidRT,'AVG_RUNTIME: ' || V_DATA(1).AVG_RUNTIME);
    utl_file.put_line (fidRT,'ECARTTYPE_RUNTIME: ' || V_DATA(1).ECARTTYPE_RUNTIME);
    utl_file.put_line (fidRT,'MEDIAN_RUNTIME: ' || V_DATA(1).MEDIAN_RUNTIME);
    utl_file.put_line (fidRT,'PERCENTILE_RUNTIME: ' || V_DATA(1).PERCENTILE_RUNTIME);
    utl_file.fclose (fidRT);
exception when others then
  if utl_file.is_open(fid) then
    utl_file.fclose (fid);
  end if;
    dbms_output.put_line('SQLCODE : ' || SQLCODE || 'SQLERRM : ' || SQLERRM);
end;
end Analyse_IdTitleVoteRunTime;