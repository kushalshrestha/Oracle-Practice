/* Introduction to use of SQL in PL/SQL block */


/* This won't run - an INTO clause is expected in this SELECT statement b/c inside PL/SQL you need INTO*/
declare
v_name varchar2(50);
v_salary employees.salary%type;
begin
select last_name, salary  from employees where employee_id=100;

end;
/

declare
v_name varchar2(50);
v_salary employees.salary%type;
begin
select last_name, salary into v_name, v_salary from employees where employee_id=100;

dbms_output.put_line('The salary of ' || v_name || ' is : '|| v_salary);

select first_name || ' ' || last_name, salary into v_name, v_salary from employees where employee_id=100;
dbms_output.put_line('The salary of ' || v_name || ' is : '|| v_salary);
end;