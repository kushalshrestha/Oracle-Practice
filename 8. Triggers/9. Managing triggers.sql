/* Exploring and managing views */
/* 
We have 2 different data dictionary views for that:
    1. USER_OBJECTS 
    2. USER_TRIGGERS
*/

select * from user_objects where object_type = 'TRIGGER';

select * from user_triggers;

/*
SYNTAX:
Alter trigger <trigger_name> [enable | disable];

alter trigger <base_object_name> [enable | disable] all triggers;

alter trigger <trigger_name> COMPILE; -- compile 

drop trigger <trigger_name>

*/