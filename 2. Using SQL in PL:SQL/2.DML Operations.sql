/* DML Operations in PL/SQL 

* We can use DML commands in PL/SQL code.
* We can use PL/SQL Variables in a DML command. -> INSERT, UPDATE, DELETE, MERGE

*/


-- Triggers, Indexes, Constraints except NOT NULL constraints are not copied
create table employees_copy 
as
select * from employees;


select * from employees_copy;

begin
    for i in 100..107 loop
        insert into employees_copy (employee_id, first_name, last_name, email, hire_date, job_id, salary)
        values (i, 'employee_id#'||i, 'temp_emp', 'abc@xmail.com', sysdate, 'IT_PROG', 1000);
    end loop;
end;
/
-- let's see new rows being inserted
select * from employees_copy;


--- now let's try update
declare
v_salary_increase number:=400;
begin
    for i in 100..107 loop
        update employees_copy
        set salary = salary + v_salary_increase
        where employee_id=i;
    end loop;
end;
/
-- let's see  rows being updated
select * from employees_copy;



--- now let's try delete
declare
v_salary_increase number:=400;
begin
    for i in 108..115 loop
        delete from employees_copy
        where employee_id=i;
    end loop;
end;

-- let's see  rows being deleted
select * from employees_copy;



