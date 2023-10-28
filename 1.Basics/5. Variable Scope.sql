/* Variable Scope */

set serveroutput on;

begin <<outer>>
DECLARE
    v_outervariable VARCHAR(200);
    v_outervariable1 VARCHAR(200);
BEGIN
    v_outervariable := 'Outer Variable';
    v_outervariable1 := 'Another Outer Variable';
    dbms_output.put_line(v_outervariable);
    DECLARE
        v_innervariable VARCHAR(200);
        v_outervariable VARCHAR(200) := 'Outer variable declared inside inner block'; -- declared again inside inner block
        v_outervariable1 VARCHAR(200) := 'Another outer variable declared inside inner block';
    BEGIN
        dbms_output.put_line('This is an inner block');
        dbms_output.put_line(v_outervariable);
        dbms_output.put_line('!!!!Outer variable gets replaced if declared in inner block ' || v_outervariable1);
        v_innervariable := 'Inner variable printed inside';
        dbms_output.put_line(v_innervariable);
        dbms_output.put_line('!!!!Accessing outer variable by block name - ' || outer.v_outervariable1);
    END;
    -- dbms_output.put_line(v_innerVariable);  -- cannot be accessed from outside the block, gives error

END;
END outer;