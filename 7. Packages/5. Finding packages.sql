/* How can I find the packages */
/*
user - your schema
all - yours + other users' that you have the privilege to execute
dba  - all

user_source / All_source / DBA_source - we get specific info about the packages, triggers etc

user_objects/ all_objects / dba_objects - we get general info about the packages and other objects like if they are valid
*/

select * from user_source;

select * from user_objects where object_type = 'PACKAGE BODY';
-- see status: VALID or INVALID
