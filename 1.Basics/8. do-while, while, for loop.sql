/* LOOPS */

-- basic loops - executes atleas one time
declare
v_counter number(2) := 0;
begin
    loop
        dbms_output.put_line('Current counter : ' || v_counter);
        v_counter := v_counter + 1;
    exit when v_counter = 10;
    end loop;
end;
/

/* WHILE LOOPS - until the condition is satisfied - might not execute even once */
declare
    v_counter number(2):=0;
begin 
    while v_counter <= 10 loop
        dbms_output.put_line('Current counter : ' || v_counter);
        v_counter := v_counter + 1;
        -- exit when v_counter = 3;     -- we can add this too
    end loop;
end;
/

/* FOR LOOPS - + reverse example  -> if you know exactly to where to start and to stop */
declare 
    v_counter number(2) := 0;
begin
    for i in  1..5 loop
        dbms_output.put_line('current number is : ' || i);
    end loop;
    
    for i in reverse 1..5 loop
        dbms_output.put_line('current number in reverse is : ' || i);
    end loop;
end;
/



    