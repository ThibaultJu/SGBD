--Tout est à faire sur sys
--CREATE_ACL
CREATE OR REPLACE PROCEDURE ACL AS 

BEGIN
	DBMS_NETWORK_ACL_ADMIN.CREATE_ACL(acl		=> 'blob.xml',
									description	=> 'BLOB images ACL',
									principal	=> 'CB',
									is_grant	=> TRUE,
									privilege	=> 'connect');

	DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL(acl	=> 'blob.xml',
									host	=> 'image.tmdb.org');

  --DBMS_NETWORK_ACL_ADMIN.DROP_ACL(acl         => 'blob.xml');                                 
COMMIT;
END ACL;

--Grant
GRANT EXECUTE ON SYS.UTL_HTTP TO PUBLIC;