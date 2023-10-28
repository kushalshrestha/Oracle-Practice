/* PL/SQL Records */
/*
We can create records in 2 ways:
1. Just pointing a database table structure -> <tableName>%ROWTYPE
2. Specify our variables one by one into our record. b/c sometimes out of 50 column we might require 35 columns
*/


-- 1. By pointing a  database table structure
declare
    r_emp employees%rowtype;
begin
    select * into r_emp 
    from employees where employee_id = '101'; -- but must return only one row
    
    dbms_output.put_line(r_emp.first_name);
    dbms_output.put_line(r_emp.first_name|| ' ' || r_emp.last_name || ' earns ' || r_emp.salary || ' and hired at : ' || r_emp.hire_date);
    
    -- Updating
    r_emp.salary := 2000;
    dbms_output.put_line(r_emp.first_name|| ' ' || r_emp.last_name || ' earns ' || r_emp.salary || ' and hired at : ' || r_emp.hire_date);

end;   
/


-- 2. By creating custom record type

declare
    type t_emp is record (first_name varchar2(50),
                            last_name employees.last_name%type,
                            salary employees.salary%type,
                            hire_date date);
    r_emp t_emp;                        
begin
    r_emp.first_name := 'Kushal';
    r_emp.salary := 2000;
    r_emp.hire_date := '01-JAN-21';
    dbms_output.put_line(r_emp.first_name || ' ' || r_emp.last_name || ' earns ' || r_emp.salary || ' and hired at : ' || r_emp.hire_date);
end;  
/

-- Let's try nested (more complex)

declare
    type t_edu is record (primary_school varchar2(100),
                            high_school varchar2(100),
                            university varchar2(100),
                            uni_graduate_date date
                            );
    type t_emp is record(first_name varchar2(50),
                        last_name employees.last_name%type,
                        salary employees.salary%type NOT NULL Default 1000,
                        hire_date date,
                        dept_id employees.department_id%type,
                        department departments%rowtype,
                        education t_edu
                        );
    r_emp t_emp;
begin

    select first_name, last_name, salary, hire_date, department_id
    into r_emp.first_name, r_emp.last_name, r_emp.salary, r_emp.hire_date, r_emp.dept_id
    from employees where employee_id='146';
    
    select * into r_emp.department
    from departments where DEPARTMENT_ID = r_emp.dept_id;
    
    r_emp.education.high_school := 'Beverly Hills';
    r_emp.education.university := 'Oxford';
    r_emp.education.uni_graduate_date := '01-JAN-13';
    
    dbms_output.put_line(r_emp.first_name || ' ' || r_emp.last_name || ' earns ' || r_emp.salary ||
            ' and hired at : ' || r_emp.hire_date);
    dbms_output.put_line('He graduated from ' || r_emp.education.university || ' at ' ||
                r_emp.education.uni_graduate_date);
    dbms_output.put_line('His department name is : ' || r_emp.department.department_name);
end;    


