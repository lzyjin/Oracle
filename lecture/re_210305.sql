
SET SERVEROUTPUT ON;

BEGIN
    IF
        '&이름' = '김예진'
    THEN
        DBMS_OUTPUT.PUT_LINE('예진아 안녕');
    END IF;
END;
/

DECLARE

    V_EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
    
BEGIN
    
    SELECT EMP_NAME
    INTO V_EMP_NAME
    FROM EMPLOYEE
    WHERE EMP_ID = '&사원아이디';

    IF
        V_EMP_NAME = '선동일'
    THEN
        DBMS_OUTPUT.PUT_LINE('난 대표야');
    ELSE
        DBMS_OUTPUT.PUT_LINE('난 대표가 아냐');
    END IF;
    
END;
/
        
   
   
DECLARE
    N NUMBER := 1;
BEGIN 
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N := N + 1;
        
        IF
            N > 10
        THEN 
            EXIT;
        END IF;
    END LOOP;
END;
/


DECLARE
    N NUMBER := 1;
BEGIN 
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        DBMS_OUTPUT.PUT_LINE(FLOOR(DBMS_RANDOM.VALUE(1, 10)));
        
        N := N + 1;
    
        EXIT WHEN N > 10;
    END LOOP;
END;
/


BEGIN
    FOR I IN 10..20 LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;
/


BEGIN
    FOR I IN REVERSE 10..20 LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;
/





        