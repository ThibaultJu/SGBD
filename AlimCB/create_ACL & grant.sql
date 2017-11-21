--Tout est à faire sur sys
--CREATE_ACL
CREATE OR REPLACE PROCEDURE ACL AS 

BEGIN
	begin
  dbms_network_acl_admin.append_host_ace (
    host => '*',
    lower_port => 80,
    upper_port => 80,
    ace         =>  xs$ace_type(privilege_list => xs$name_list('http'),
                          principal_name => 'cb',
                          principal_type => xs_acl.ptype_db));
end;

  --DBMS_NETWORK_ACL_ADMIN.DROP_ACL(acl         => 'blob.xml');                                 
COMMIT;
END ACL;

--Grant
GRANT EXECUTE ON SYS.UTL_HTTP TO PUBLIC;