/* %TYPE Attribute 
WHY TO USE IT? To adjust with the change of data type, precision, scale quickly
Eg: Let's say a column salary has precision,scale of 8,2. Now a new guy gets hired with huge salary.
Then there will be an issue because of the prescision, scale. So, to solve this you have to change the precision-scale to many
columns which is error prone. So, %TYPE attribute is there for you.
/

-- desc employee

declare
v_type employees.job_id%type;
v_type1 v_type%type; -- can be nested
begin
v_type:= 'IT_PROG';
dbms_output.put_line(v_type);
-- v_type:= 'ADMINISTRATOR';
-- dbms_output.put_line(v_type); -- will give error
 v_type1:= 'ADMIN';
 dbms_output.put_line(v_type1); 

end;