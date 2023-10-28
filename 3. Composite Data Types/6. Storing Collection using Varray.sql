/* Storing Collection in Tables i.e storing varrays and nested tables in database tables*/
/*
 - But we cannont store associative arrays as schema-level
 - Varrays and Nested Tables can be stored, but in different ways. Also called "Storage Table"
 - Why we need? We can use join but for faster performance, reduce join we can use it
        * Varrays are lower than 4KB. If it is stored under 4KB it resides on the same table else in another table. 
            The table is created by the system automatically and resides in the same tablespace and in the same segment with the table.
            
*/

-- gives error b/c record cannot be stored, but there's 'object' we can use
create or replace type t_phone_number as record(p_type varchar2(10), p_number varchar2(50));
/

/* create from system admin user */
create or replace type hr.t_phone_number as object(p_type varchar2(10), p_number varchar2(50));
create or replace type hr.v_phone_numbers as varray(3) of t_phone_number;

create table emps_with_phones (employee_id number,
                                first_name varchar2(50),
                                last_name varchar2(50),
                                phone_number v_phone_numbers);
                                
select * from emps_with_phones; -- will not give proper view

insert into emps_with_phones values (10, 'Alex', 'Shrestha', v_phone_numbers(
                                                                            t_phone_number('HOME', '23439240234'),
                                                                            t_phone_number('WORK', '3249032432'),
                                                                            t_phone_number('MOBILE', '13490584393')
                                                                            ));
insert into emps_with_phones values (10, 'Messi', 'Shrestha', v_phone_numbers(
                                                                            t_phone_number('HOME', '2384892311'),
                                                                            t_phone_number('WORK', '4444 444 44')
                                                                            ));                                                                            
-- to show properly
-- 1. jointing with 'table(e.column_name)'
select e.first_name, e.last_name, p.p_type, p.p_number
from emps_with_phones e,
    table(e.phone_number) p;

    
    