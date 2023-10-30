/* INSTEAD OF TRIGGERS */
/*
- Instead triggers are used only with the views 
- Generally used for the complex views, but can be done on simple views
- !!! If your view has a check option, it won't be enforced when you use the instead of triggers
- !!! Before and after timing options are not valid for instead of triggers
*/

create table departments_copy
as 
select * from departments;
/

create or replace view vw_emp_details
as
select upper(department_name) dname, min(salary) min_sal, max(salary) max_sal
from employees_copy
join departments_copy
using (department_id)
group by department_name;
/
-- we get error "data manipulation operation not legal on this view
update vw_emp_details
set dname = 'EXEC DEPT'
where upper(dname)='EXECUTIVE';
/
-- to make the data manipulation we need to use INSTEAD OF

create or replace trigger emp_details_vw_dml
instead of insert or update or delete 
on vw_emp_details
for each row
declare
    v_dept_id pls_integer;
begin
    if inserting then
        select max(department_id) + 10 
        into v_dept_id
        from departments_copy;
        
        insert into departments_copy
        values (v_dept_id, :new.dname, null, null);
    elsif deleting then
        delete from departments_copy
        where upper(department_name) = upper(:old.dname);
    elsif updating('dname') then
        update departments_copy
        set department_name = :new.dname
        where upper(department_name) = upper(:old.dname);
    else
        raise_application_error(-20134, 'you cannot update any data other than department name');
    end if;
end;  
/

update vw_emp_details
set dname = 'EXEC DEPT'
where upper(dname)='EXECUTIVE';

select * from departments_copy;

select * from vw_emp_details;

/

delete from vw_emp_details
where dname='EXEC DEPT';

select * from departments_copy;

/
insert into vw_emp_details
values ('Executive', null, null);


select * from departments_copy;

select * from vw_emp_details; -- but won't be in the view b/c there's no employee id associated with the department
/

update vw_emp_details
set min_sal = 5000
where dname = 'ACCOUNTING';


