
-- 0305

-- 배운 내용 : PL/SQL 조건문 반복문, PROCEDURE, FUNCTION, TRIGGER


-- PL/SQL 조건문
-- 사용법 :  실행문에 사용
-- IF 조건식 THEN 조건이 true일 때 실행할 로직  END IF.

BEGIN 
    IF 
        '&이름' = '김태희'
    THEN 
        DBMS_OUTPUT.PUT_LINE('상현이 형이 괴롭혀요 ㅋㅋ');
    END IF;
END;
/



DECLARE
    V_EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN
    SELECT EMP_NAME
    INTO V_EMP_NAME
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    IF
        V_EMP_NAME = '선동일'
    THEN 
        DBMS_OUTPUT.PUT_LINE('난 대표');
    END IF;
END;
/

-- 200을 입력하면 '난 대표' 출력 



-- IF ~ THEN ~ ELSE ~  END IF.
-- 자바에서의 if else 문 

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
        DBMS_OUTPUT.PUT_LINE('대표다');
    ELSE
         DBMS_OUTPUT.PUT_LINE('아니다. 사원이다.');
    END IF;
END;
/

-- EMP_ID = 200이면 대표다, 200이 아니면 아니다. 사원이다. 출력 



-- IF ~ THEN ~ ELSIF ~ ELSE ~ END IF.

DECLARE
    V_JOB_CODE EMPLOYEE.JOB_CODE%TYPE;
BEGIN 
    SELECT JOB_CODE
    INTO V_JOB_CODE
    FROM EMPLOYEE
    WHERE EMP_ID = '&사원아이디';

    IF 
        V_JOB_CODE = 'J1'
    THEN
        DBMS_OUTPUT.PUT_LINE('대표다');
    ELSIF
        V_JOB_CODE = 'J2'
    THEN 
        DBMS_OUTPUT.PUT_LINE('임원이다');
    ELSE
        DBMS_OUTPUT.PUT_LINE('아니다. 사원이다.');
    END IF;
END;
/
    
    
    
-- CASE문 

DECLARE 
    INPUTVALUE NUMBER;
BEGIN 
    INPUTVALUE := '&수입력';

    CASE INPUTVALUE 
        WHEN 1 
            THEN DBMS_OUTPUT.PUT_LINE(INPUTVALUE || '를 입력함. 1은 첫번째');
        WHEN 2 
            THEN DBMS_OUTPUT.PUT_LINE(INPUTVALUE || '를 입력함. 2는 두번째');
        WHEN 3 
            THEN DBMS_OUTPUT.PUT_LINE(INPUTVALUE || '를 입력함. 3는 세번째');
        ELSE
            DBMS_OUTPUT.PUT_LINE(INPUTVALUE || '를 입력함. 3이상은 몰라~');
    END CASE;
END;
/
    

DECLARE
    VSALARY EMPLOYEE.SALARY%TYPE;
BEGIN
    SELECT SALARY
    INTO VSALARY
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';    
    
    CASE 
        WHEN VSALARY > 4000000
            THEN DBMS_OUTPUT.PUT_LINE('고액연봉자');
        WHEN VSALARY > 2000000
            THEN DBMS_OUTPUT.PUT_LINE('연봉자');
        ELSE 
           DBMS_OUTPUT.PUT_LINE('슬프다...');
    END CASE;
END;
/


-- 반복문
-- 기본반복문 : LOOP

-- LOOP 실행할 구문 END LOOP -> 기본적으로 무한루프를 돈다 
-- 무한루프를 멈추게 하고싶으면 조건 필요 

-- EXIT : 반복문을 빠져나오는 예약어 


-- 1부터 10까지 순서대로 출력

DECLARE
    N NUMBER := 1;
BEGIN

    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N := N + 1;
        
 --       IF 
 --           N > 10
 --       THEN 
 --           EXIT;
 --       END IF;
            
 -- 이렇게 써도 된다
        EXIT WHEN N > 10;
            
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
        
 --       IF 
 --           N > 10
 --       THEN 
 --           EXIT;
 --       END IF;
            
 -- 이렇게 써도 된다
        EXIT WHEN N > 10;
            
    END LOOP;
    
END;
/  
    
    
    
-- WHILE 조건식 
     -- LOOP   
     -- 실행구문 
     -- END LOOP
  
DECLARE
    N NUMBER := 1;
BEGIN
    WHILE N <= 5 LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N := N + 1;
    END LOOP;
END;
/
        
    
    
    
    
--사번을 입력 받은 후 급여에 따라 등급을 나누어 출력하도록 하시오 
--그때 출력 값은 사번,이름,급여,급여등급을 출력하시오 (CASE 문으로 출력하시오)
--0만원 ~ 99만원 : F
--100만원 ~ 199만원 : E
--200만원 ~ 299만원 : D
--300만원 ~ 399만원 : C
--400만원 ~ 499만원 : B
--500만원 이상(그외) : A

DECLARE

    V_SALARY EMPLOYEE.SALARY%TYPE;
    
BEGIN

    SELECT SALARY
    INTO V_SALARY
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';

    CASE 
    
        WHEN V_SALARY BETWEEN 0 AND 990000
            THEN DBMS_OUTPUT.PUT_LINE('F');
            
        WHEN V_SALARY BETWEEN 1000000 AND 1990000
            THEN DBMS_OUTPUT.PUT_LINE('E');
            
        WHEN V_SALARY BETWEEN 2000000 AND 2990000
            THEN DBMS_OUTPUT.PUT_LINE('D');
            
        WHEN V_SALARY BETWEEN 3000000 AND 3990000
            THEN DBMS_OUTPUT.PUT_LINE('C');
            
        WHEN V_SALARY BETWEEN 4000000 AND 4990000
            THEN DBMS_OUTPUT.PUT_LINE('B');
            
        WHEN V_SALARY >= 5000000 
            THEN DBMS_OUTPUT.PUT_LINE('A');
            
    END CASE;
    
END;
/

SELECT *
FROM EMPLOYEE;



-- FOR LOOP
-- 자바의 FOR EACH문과 유사 

-- FOR 변수 IN 범위 LOOP
--  실행구문
-- END LOOP;


-- 1부터 10까지 출력하는 반복문

BEGIN 
    FOR I IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;
/


-- 10부터 1까지 출력하는 반복문

-- 이렇게 하면 안돼 
-- 범위는 작은 숫자부터 적어야해 
BEGIN 
    FOR I IN 10..1 LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;
/


-- 제대로 된 방법 : REVERSE 사용 

BEGIN 
    FOR I IN REVERSE 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;
/





-- FOR LOOP를 이용해서 EMPLOYEE테이블의 10개의 행 출력하기 
-- EMP_ID, EMP_NAME, SALARY

DECLARE

    VEMP_ID EMPLOYEE.EMP_ID%TYPE;
    VEMP_NAME EMPLOYEE.EMP_NAME%TYPE;
    VSALARY EMPLOYEE.SALARY%TYPE;
    VMAXEMP_ID EMPLOYEE.EMP_ID%TYPE;
    VMINEMP_ID EMPLOYEE.EMP_ID%TYPE;
    

BEGIN

    SELECT EMP_ID, EMP_NAME, SALARY-- , MAX(EMP_ID), MIN(EMP_ID)
    INTO VEMP_ID, VEMP_NAME, VSALARY-- , VMAXEMP_ID, VMINEMP_ID
    FROM EMPLOYEE
    WHERE EMP_ID=200; -- 이 조건 꼭 필요 
    -- WHERE EMP_ID > = 200;
    -- WHERE EMP_ID BETWEEN MIN(EMP_ID) AND MAX(EMP_ID);
    --WHERE   
        --FOR EMPLOYEE.EMP_ID IN 200..300 LOOP
            --EMP_ID := EMP_ID + 1;
        --END LOOP;
    
    
    FOR I IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE(VEMP_ID || ' ' || VEMP_NAME || ' ' || VSALARY);
    END LOOP;
    
END;
/




-- 다시 풀어보기 

DECLARE 
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO E
    FROM EMPLOYEE
    WHERE 
        FOR A IN 200..222 LOOP
            E.EMP_ID := E.EMP_ID + 1;
        END LOOP;
        
        E.EMP_ID = EMP_ID;
        
    
    FOR I IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE(E.EMP_ID || ' ' || E.EMP_NAME || ' ' || E.SALARY);
    END LOOP;
END;
/
    

SELECT *
FROM EMPLOYEE;


-- 답을 알고난 후
DECLARE

    VEMPID EMPLOYEE.EMP_ID%TYPE;
    E EMPLOYEE%ROWTYPE;
    
BEGIN
    
    VEMPID := 200;

    FOR I IN 1..10 LOOP
        
        SELECT *
        INTO E
        FROM EMPLOYEE
        WHERE VEMPID = EMP_ID;
        
        VEMPID := VEMPID + 1;
        
        DBMS_OUTPUT.PUT_LINE(VEMPID || ' ' || E.EMP_NAME || ' ' || E.SALARY);
    
    END LOOP;
    
END;
/


-- 상현이 푼 답
DECLARE
            E EMPLOYEE%ROWTYPE;
            N number:= 200;
        BEGIN
          
        
           
            FOR I IN 1..10 LOOP
            
                SELECT *
                INTO E
                FROM EMPLOYEE
                WHERE EMP_ID = N;
                N:=N+1;
                
                DBMS_OUTPUT.PUT_LINE(E.EMP_ID||' '||E.EMP_NAME||' '||E.SALARY);
                 
                 
            END LOOP;
        END;
        /


-- 선생님 풀이 

DECLARE 

    V_EMP_ID EMPLOYEE.EMP_ID%TYPE;
    E EMPLOYEE%ROWTYPE;
    
BEGIN 

    V_EMP_ID := 200;


    FOR K IN 1..10 LOOP 
    
        SELECT *
        INTO E
        FROM EMPLOYEE
        WHERE EMP_ID = V_EMP_ID; -- V_EMP_ID가 바뀐값이 들어와서 그 아이디의 사원정보가 출력될 수 있게 FOR문 안에 SELECT문을 작성해야한다.
        
        V_EMP_ID := V_EMP_ID + 1;
        DBMS_OUTPUT.PUT_LINE(E.EMP_ID || ' ' || E.EMP_NAME || ' ' || E.SALARY);
        
    END LOOP;
    
END;
/







-- PROCEDURE 
-- PL/SQL 구문을 저장해서 이용하게 하는 객체 

-- 샘플 데이터 생성 
CREATE TABLE PRO_TEST
AS SELECT * FROM EMPLOYEE;

SELECT *
FROM PRO_TEST;



-- 프로시져 생성

CREATE PROCEDURE DEL_DATA
IS 
-- (지역변수 생성)
BEGIN   
    DELETE FROM PRO_TEST;
    COMMIT;
END;
/

-- Procedure DEL_DATA이(가) 컴파일되었습니다.


-- 생성된 프로시져 조회
SELECT *
FROM USER_PROCEDURES;


-- 생성된 프로시져 실행하기
EXEC DEL_DATA;
-- PL/SQL 프로시저가 성공적으로 완료되었습니다.


SELECT *
FROM PRO_TEST;
-- ROW(데이터)가 다 지워졌다. 




-- 프로시져에 매개변수를 선언할 수 있다. 
-- IN : 프로시져를 실행할 때 필요한 값을 받는 변수(자바에서의 매개변수와 동일한 역할)(반환값이 없는 메소드와 비슷)
-- OUT : 호출한 쪽에서 되돌려주는 변수 => 결과값 (반환이 아님)

-- 만약에 있다고 에러나면 create뒤에 OR REPLACE 작성하기 

CREATE PROCEDURE PRO_SELECT_EMP(V_EMP_ID IN EMPLOYEE.EMP_ID%TYPE, 
                                V_EMP_NAME OUT EMPLOYEE.EMP_NAME%TYPE,
                                V_SALARY OUT EMPLOYEE.SALARY%TYPE,
                                V_BONUS OUT EMPLOYEE.BONUS%TYPE)
IS 
BEGIN
    SELECT EMP_NAME, SALARY, BONUS
    INTO V_EMP_NAME, V_SALARY, V_BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = V_EMP_ID;
END;
/

-- Procedure PRO_SELECT_EMP이(가) 컴파일되었습니다.



-- 매개변수 있는 프로시져 실행하기

VAR EMP_NAME VARCHAR2(20);
VAR SALARY NUMBER;
VAR BONUS NUMBER;

PRINT EMP_NAME;
PRINT SALARY;
PRINT BONUS;

EXEC PRO_SELECT_EMP(200, :EMP_NAME, :SALARY, :BONUS);
-- PL/SQL 프로시저가 성공적으로 완료되었습니다.

PRINT EMP_NAME; -- 선동일 
PRINT SALARY; -- 8000000
PRINT BONUS; -- 0.3  출력 





-- FUNCTION 만들기
-- 반환형이 있다 

CREATE OR REPLACE FUNCTION MYFUNC(V_STR VARCHAR2) -- 매개변수 없으면 ()이대로써도 된다 
RETURN VARCHAR2
IS
    RESULT VARCHAR2(1000);
BEGIN
    DBMS_OUTPUT.PUT_LINE(V_STR);
    -- RETURN V_STR; -- 리턴값이 있어서 꼭 받아야함 
    RETURN '*' || V_STR || '*';
END;
/


SELECT MYFUNC('김예진')
FROM DUAL;





-- EMP_ID를 전달받아 연봉을 계산해서 출력하는 함수 만들기 

CREATE OR REPLACE FUNCTION NEWFUNC(ID EMPLOYEE.EMP_ID%TYPE)
RETURN NUMBER
IS
    S EMPLOYEE.SALARY%TYPE;
    CS NUMBER;
    
BEGIN
    SELECT SALARY
    INTO S
    FROM EMPLOYEE
    WHRER ID = EMP_ID;
    
    CS = S*12;
    RETURN CS;
    
END;
/
    



-- 선생님 풀이
-- 회사에서는 OR REPLACE 쓰지 말자 -> 다른사람이 만든걸 대체해버릴수도 있으니까

CREATE OR REPLACE FUNCTION CALCSALARY(V_EMP_ID EMPLOYEE.EMP_ID%TYPE)
RETURN NUMBER
IS 
    E EMPLOYEE%ROWTYPE;
    RESULT NUMBER;
    
BEGIN 

    SELECT *
    INTO E
    FROM EMPLOYEE
    WHERE EMP_ID = V_EMP_ID; -- 이렇게 조건 주는거 기억하기!!!!!!!!!!!!!!!!!!!!
    
    RESULT := (E.SALARY + (E.SALARY * NVL(E.BONUS, 0)) * 12);
    RETURN RESULT;
    
END;
/

-- 펑션 확인
SELECT EMP_ID, CALCSALARY(EMP_ID)
FROM EMPLOYEE;






-- TRIGGER 
-- 테이블이나 뷰가 INSERT, UPDATE, DELETE 등의 DML문에 의해 변경될 경우 
-- 자동으로 실행될 내용을 정의하여 저장하는 객체

CREATE OR REPLACE TRIGGER TRG_02
AFTER INSERT -- INSERT한 후에 트리거 실행 
ON EMPLOYEE 
FOR EACH ROW
BEGIN

    -- 이코드 추가작성
    DBMS_OUTPUT.PUT_LINE(:NEW.EMP_ID || :NEW.EMP_NAME); -- FOR EACH ROW 필요 !!!
    DBMS_OUTPUT.PUT_LINE(:OLD.EMP_ID || :OLD.EMP_NAME);
    
    DBMS_OUTPUT.PUT_LINE('신입이 등록되었습니다');
END;
/
-- Trigger TRG_02이(가) 컴파일되었습니다.



INSERT INTO EMPLOYEE VALUES (905, '길성춘', '690512-1151432', 
                             'gil_sj@kh.or.kr', '01035464455', 'D5', 'J3',
                             'S5', 3000000, 0.1, 200, SYSDATE, NULL, DEFAULT);
-- 신입이 등록되었습니다
-- 1 행 이(가) 삽입되었습니다.  출력 




-- TRIGGER 속성
-- 1. 실행 시점 : BEFORE(실행 전) / AFTER (실행 후)
-- 2. 실행 시키는 명령어 : INSERT / UPDATE / DELETE 
-- 3. FOR EACH ROW : 각 행마다 트리거를 발동시킴, 만약 FOR EACH ROW가 없다면 해당 테이블에 1번 발동 
-- 4. 기존값, 신규값 가져오기 
    -- OLD.: 수정되기 전의 값  /  NEW. : 수정된 후 추가되는 값(새로운 값)
    

CREATE OR REPLACE TRIGGER TRG03 
AFTER UPDATE
ON EMPLOYEE
FOR EACH ROW
BEGIN

    DBMS_OUTPUT.PUT_LINE(:OLD.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE(:OLD.SALARY);
    
    DBMS_OUTPUT.PUT_LINE(:NEW.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE(:NEW.SALARY);
    
END;
/
-- Trigger TRG03이(가) 컴파일되었습니다.



UPDATE EMPLOYEE SET EMP_NAME = '박찬혁', SALARY = 200 WHERE EMP_ID = '905'; 
DESC EMPLOYEE;

SELECT *
FROM EMPLOYEE;






-- 재고관리 테이블에 트리거 적용하기

-- 상품 테이블 
CREATE TABLE PRODUCT(
    PCODE NUMBER PRIMARY KEY, -- 상품 시리얼번호 
    PNAME VARCHAR2(30),
    BRAND VARCHAR2(30),
    PRICE NUMBER, 
    STOCK NUMBER DEFAULT 0
);


-- 상품에 대한 입출고를 관리하는 테이블
CREATE TABLE PRODUCT_IO(
    IOCODE NUMBER PRIMARY KEY, -- 
    PCODE NUMBER CONSTRAINT FK_PIO_PCODE REFERENCES PRODUCT(PCODE),
    PDATE DATE, 
    AMOUNT NUMBER,
    STATUS VARCHAR2(10) CHECK( STATUS IN ('입고', '출고') )
);

-- DROP TABLE PRODUCT_IO;


-- 시퀀스 적용
CREATE SEQUENCE SEQ_PCODE;

CREATE SEQUENCE SEQ_IOCODE;



SELECT *
FROM PRODUCT;

SELECT *
FROM PRODUCT_IO;



INSERT INTO PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '아이폰12', '애플', 1200000, DEFAULT);
INSERT INTO PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '미니홈', '애플', 120000, DEFAULT);
INSERT INTO PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '자동차', 'E-CLASS', 100000000, DEFAULT);


SELECT *
FROM PRODUCT;


-- 트리거 생성 

CREATE TRIGGER PRODUCT_TRG 

    AFTER INSERT 

    ON PRODUCT_IO

    FOR EACH ROW

    BEGIN
    
        IF :NEW.STATUS = '입고'
            THEN 
                UPDATE PRODUCT 
                SET STOCK = STOCK + :NEW.AMOUNT  -- NEW : 앞으로 새로 들어올 값 
                WHERE PCODE = :NEW.PCODE; 
        ELSIF :NEW.STATUS = '출고'
            THEN 
                UPDATE PRODUCT
                SET STOCK = STOCK - :NEW.AMOUNT
                WHERE PCODE = :NEW.PCODE;
        END IF;
    END;
/
-- Trigger PRODUCT_TRG이(가) 컴파일되었습니다.



-- 입고출고로 PRODUCT_IO...
SELECT *
FROM PRODUCT;

INSERT INTO PRODUCT_IO VALUES(SEQ_IOCODE.NEXTVAL, 1, SYSDATE, 10, '입고'); -- 아이폰12의 STOCK이 10이 된다 
INSERT INTO PRODUCT_IO VALUES(SEQ_IOCODE.NEXTVAL, 3, SYSDATE, 5, '입고'); -- 자동차의 STOCK이 5가 된다

INSERT INTO PRODUCT_IO VALUES(SEQ_IOCODE.NEXTVAL, 1, SYSDATE, 3, '출고'); -- 아이폰12의 STOCK이 7이 된다 



-- 오라클 끝 ~~~~!!!!!!! 







    