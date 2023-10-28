/* USING BIND VARIABLES
- we declare bind variables outside the block. These are host variables.
In the context of Oracle PL/SQL and other database programming languages, "host variables" refer to variables declared 
and defined in the host programming language, typically outside the database block or stored procedure. 
These host variables are used to pass data between the host program (such as a C++, Java, or other application) and the database.

* helpful for performance
* helpful for multi block reach
*/

set serveroutput on;
variable var_text varchar2(30);
variable another_bind_variable_number number;

declare
v_text varchar2(30);

begin
    :var_text := 'Hello PL/SQL';
    v_text:= :var_text;
    :another_bind_variable_number:=30;
    dbms_output.put_line(v_text);
    
    dbms_output.put_line(:var_text);
    
    dbms_output.put_line(:another_bind_variable_number);
end;
/

print var_text;
/

/
-- using sql query

variable var_sql number;

begin
    :var_sql:='100';
end;

select * from employees where employee_id = :var_sql;