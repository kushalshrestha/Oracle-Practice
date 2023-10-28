/* SEQUENCES in PL/SQL */
/*
we can use nextval or curval

*/

drop table employees_copy;
create table employees_copy
as
select * from employees;
/

select * from employees_copy;
-- Let's create a sequence
create sequence employee_id_seq
start with 207
increment by 1;

-- now let's insert

begin
    for i in 1..10 loop
        insert into employees_copy(employee_id, first_name, last_name, email, hire_date, job_id, salary)
        values
        (employee_id_seq.nextval, 'employee#'||employee_id_seq.nextval, 'temp_emp', 'abc@xmail.com', sysdate, 'IT_PROG', 1000);
    end loop;
end; 
--!!!IMPORTANT -- even if you use 'next_val' in a statement twice, it'll increase only one time for one statement
/

select * from employees_copy;

/

declare
    v_seq_num number;
begin
    select employee_id_seq.nextval into v_seq_num from dual;
    dbms_output.put_line(v_seq_num);
end; 
/


-- This will give error b/c multiple records cannot be fetched when 'into' is used
declare
    v_seq_num number;
begin
    select employee_id_seq.nextval into v_seq_num from employees_copy;
    dbms_output.put_line(v_seq_num);
end; 
/

--So,
declare
    v_seq_num number;
begin
    select employee_id_seq.nextval into v_seq_num from employees_copy
    where rownum=1;
    dbms_output.put_line(v_seq_num);
end; 
/


declare
    v_seq_num number;
begin
    select employee_id_seq.nextval into v_seq_num from employees_copy
    where rownum=1;
    dbms_output.put_line(v_seq_num);
end; 
/

declare 
    v_seq_num number;
begin
    v_seq_num := employee_id_seq.nextval;
    dbms_output.put_line(v_seq_num);
end;  
/

begin
    dbms_output.put_line(employee_id_seq.nextval);
end;  
/

-- NOW USING currval. currval will always gives same sequence number

begin
    dbms_output.put_line(employee_id_seq.currval);
end;  
/
