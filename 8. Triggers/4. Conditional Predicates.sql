/* Using Conditional Predicates */

---------------------------------------------------------------------------------------------
--------------------------------USING CONDITIONAL PREDICATES --------------------------------
---------------------------------------------------------------------------------------------
create or replace trigger before_row_emp_cpy 
before insert or update or delete on employees_copy 
referencing old as O new as N
for each row
begin
  dbms_output.put_line('Before Row Trigger is Fired!.');
  dbms_output.put_line('The Salary of Employee '||:o.employee_id
    ||' -> Before:'|| :o.salary||' After:'||:n.salary);
  if inserting then
    dbms_output.put_line('An INSERT occurred on employees_copy table');
  elsif deleting then
    dbms_output.put_line('A DELETE occurred on employees_copy table');
  
  elsif updating then
    begin
        if updating('salary') then
            dbms_output.put_line('An UPDATE occurred on the salary column');
        elsif updating('commission_pct') then
            dbms_output.put_line('An UPDATE occurred on the updating column');
        else
            dbms_output.put_line('An UPDATE occurred on the other columns');
        end if;
    end;
  end if;
end;
/

update employees_copy set salary=salary+100 where department_id=30;

update employees_copy set commission_pct = 0.1 where department_id = 30;