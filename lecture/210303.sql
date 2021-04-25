
-- 0303

-- 배운 내용 : CREATE TABLE, DML, DDL, DCL 





-- 서브쿼리를 이용한 테이블 생성하기 
-- 모든 컬럼명과 데이터 타입, 값이 복사된다. 제약조건은 NOT NULL만 복사된다. 

-- CREATE TABLE 테이블명 ( 컬럼 내용 설정 )
-- CREATE TABLE AS 서브쿼리

CREATE TABLE EMP_COPY 
AS SELECT * FROM EMPLOYEE;

SELECT *
FROM EMP_COPY;

DROP TABLE EMP_COPY;



-- 원하는대로 테이블을 합쳐서 만들수 있다 (복사할 수 있다)

CREATE TABLE EMP_DEP_COPY 
AS SELECT * FROM EMPLOYEE LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

SELECT *
FROM EMP_DEP_COPY;



-- 틀만 필요하면 (컬럼명이나 컬럼 개수..)

CREATE TABLE DEP_COPY
AS SELECT * FROM DEPARTMENT WHERE 1 = 0; -- 이 조건 false

-- WHERE절은 그 조건이 true를 만족하는 행만 리턴하므로 
-- 조건이 무조건 false가 되게 하면 아무 행도 출력하지 않게 할 수 있음 

SELECT *
FROM DEP_COPY;



-------------------------- DML - CREATE 문 끝 ! -----------------------------------


----------------------------- DML - INSERT, UPDATE, DELETE -----------------------




-- INSERT문
-- INSERT INTO 테이블명( 컬럼명들 ( 모든 컬럼 선택시 생략 가능 ) ) VALUES( 컬럼명들 )
-- VALUES에 컬럼의 순서를 지켜서 값을 작성해야한다.  
-- INSERT는 한번에 한 행씩만 추가할 수 있음 ( 한번에 한개의 데이터만 삽입 ) 


-- 데이터를 추가할 때 주의해야할 점은 각 컬럼의 제약조건을 잘 지켜야한다
-- 테이블의 컬럼에 NOT NULL 제약조건이 있으면 INSERT할 때 무조건 값을 넣어야 한다


-- 방법 1. 컬럼을 지정해서 데이터를 삽입
-- INSERT INTO 테이블명( 컬럼명, 컬럼명, 컬럼명, ... ) VALUES(값1, 값2, ...) : 데이터 타입을 맞춰서 작성 
-- 지정되지 않은 컬럼에는 NULL이 들어간다. -> NOT NULL제약조건에 주의! 

-- 방법 2. 전체 컬럼에 데이터를 삽입 
-- INSERT INTO 테이블명 VALUES(값1, 값2, ...) : 테이블에 선언된 모든 컬럼의 값을 다 넣어야한다. 



SELECT *
FROM DEPARTMENT;

DESC DEPARTMENT; -- 컬럼의 데이터 타입 확인 

INSERT INTO DEPARTMENT(DEPT_ID, DEPT_TITLE, LOCATION_ID) VALUES('D0', '자바연구부', 'L2');

INSERT INTO DEPARTMENT VALUES('D', '오라클연구부', 'L3');



DELETE FROM DEPARTMENT WHERE DEPT_ID = 'D0';


INSERT INTO DEPARTMENT(DEPT_TITLE, LOCATION_ID) VALUES('JDBC연구부', 'L5'); -- 오류 : DEPT_ID가 PK라서 NULL을 넣을 수 없기 때문

INSERT INTO DEPARTMENT(DEPT_ID, LOCATION_ID) VALUES('D0', 'L5'); -- 가능. 대신 DEPT_TITLE 이 NULL로 나옴 

SELECT *
FROM DEPARTMENT;





-- EMPLOYEE 테이블에 내 정보를 삽입

SELECT *
FROM EMPLOYEE;

INSERT INTO EMPLOYEE VALUES('300', '김예진', '960626-2077117', '12-47@naver.com', '01040857209', 'D9', 'J1', 'S1', 9000000, 0.5, '200', '21/10/10', NULL, 'N');

DELETE EMPLOYEE
WHERE EMP_NAME = '김예진';




-- INSERT문 활용하기
-- 1. 서브쿼리 이용해서 INSERT 

CREATE TABLE INSERT_TEST 
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE FROM EMPLOYEE JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID WHERE 1 = 0;

SELECT *
FROM INSERT_TEST;

INSERT INTO INSERT_TEST VALUES('999', '김리제', '자바연구부');


-- VALUES 쓰는 대신에 ()안에 서브쿼리를 작성 -> 그 서브쿼리의 RESULTSET을 한꺼번에 가져와서 행을 통째로 다 삽입 
-- INSERT INTO 테이블명(서브쿼리);

INSERT INTO INSERT_TEST(SELECT EMP_ID, EMP_NAME, DEPT_TITLE 
                        FROM EMPLOYEE JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID); -- 22개 행이 삽입  
                        
DELETE FROM INSERT_TEST;

INSERT INTO INSERT_TEST(SELECT EMP_ID, EMP_NAME, DEPT_TITLE 
                        FROM EMPLOYEE JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID 
                        WHERE DEPT_CODE = 'D5'); -- 6개 행 삽입 
                    
SELECT *
FROM INSERT_TEST;




-- 원하는 컬럼을 지정해서 넣을 수 있음  
-- VALUES를 생략하고 이렇게 쓸 수 있음 
-- 두번쨰 괄호의 서브쿼리의 결과(RESULT SET)를 한행 한행씩 1:1로 매칭해서 EMP_ID, EMP_NAME에 넣음 

INSERT INTO INSERT_TEST(EMP_ID, EMP_NAME)(SELECT EMP_ID, EMP_NAME FROM EMPLOYEE WHERE DEPT_CODE = 'D6'); -- 3개 행 삽입 




-- INSERT ALL
-- 2개 이상의 테이블에 값을 넣을 때 사용
-- 1개의 쿼리문에서 2개의 테이블에 각각 값을 넣을 때 사용 


-- 테이블 2개 생성 

CREATE TABLE EMP_HIRE_DATE
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE FROM EMPLOYEE WHERE 1=0; -- 이 resultset을 이름만 바꿔서 새로 만드는 .. 

CREATE TABLE EMP_MANAGER
AS SELECT EMP_ID, EMP_NAME, MANAGER_ID FROM EMPLOYEE WHERE 1=0;


SELECT *
FROM EMP_HIRE_DATE;

SELECT *
FROM EMP_MANAGER;



INSERT ALL 
    INTO EMP_HIRE_DATE VALUES(EMP_ID, EMP_NAME, HIRE_DATE)
    INTO EMP_MANAGER VALUES(EMP_ID, EMP_NAME, MANAGER_ID) -- 여기까지 INSERT문 
SELECT EMP_ID, EMP_NAME, HIRE_DATE, MANAGER_ID FROM EMPLOYEE; -- 서브쿼리  -- 48개 행 삽입 ( 24 + 24 )   



SELECT *
FROM EMP_HIRE_DATE;

SELECT *
FROM EMP_MANAGER;





-- 조건에 따라 데이터를 각 테이블에 분리하여 저장하기

CREATE TABLE EMP_OLD
AS SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE FROM EMPLOYEE WHERE 1=0;

CREATE TABLE EMP_NEW
AS SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE FROM EMPLOYEE WHERE 1=0;


SELECT *
FROM EMP_OLD;

SELECT *
FROM EMP_NEW;


-- 00/01/01을 기준으로 이전 입사자는 EMP_OLD, 이후 입사자는 EMP_NEW
INSERT ALL
    WHEN HIRE_DATE < '00/01/01' 
        THEN INTO EMP_OLD VALUES(EMP_ID, EMP_NAME, SALARY, HIRE_DATE)
    WHEN HIRE_DATE >= '00/01/01' 
        THEN INTO EMP_NEW VALUES(EMP_ID, EMP_NAME, SALARY, HIRE_DATE)
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE;


SELECT *
FROM EMP_OLD; -- 9명 

SELECT *
FROM EMP_NEW; -- 15명 







-- UPDATE문 
-- 한 개 또는 그 이상의 ROW(데이터)를 수정하는 명령어

-- UPDATE 테이블명 SET 컬럼명 =  값, 컬럼명 = 값, ... WHERE 조건식; - WHERE절 절대 생략하지 않기!! 큰일나!!!!생략하면 전체 데이터를 바꿔버림 ( 전체를 덮어써버림 -> 원본값을 찾을 수 없어!!! )


-- 샘플 데이터 생성 
SELECT *
FROM DEPT_COPY;

CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;

UPDATE DEPT_COPY SET DEPT_TITLE = '자바연구부'; -- 11개가 바뀌어버림 ..... 오마이갓 !  -> 한번의 기회는 있다 ROLLBACK 
-- ROLLBACK;

UPDATE DEPT_COPY SET DEPT_TITLE = '자바연구부' WHERE DEPT_ID = 'D0'; -- PK로 조건 설정하기 (유일한 값이니까 확실하게 원하는 데이터만 수정할 수 있게)

SELECT *
FROM DEPT_COPY;





-- 다수의 컬럼을 수정하려면

UPDATE DEPT_COPY SET DEPT_TITLE = 'JDBC연구부', 
                    DEPT_ID = 'K1', 
                    LOCATION_ID = 'L4' WHERE DEPT_ID = 'D';
-- ROLLBACK;

SELECT *
FROM DEPT_COPY;

COMMIT;
ROLLBACK;

SELECT *
FROM DEPT_COPY; -- 이미 COMMIT했기 때문에 전으로 돌아갈 수 없음 





-- UPDATE에서 서브쿼리 이용하기

-- 샘플 데이터 생성
CREATE TABLE EMP_SALARY
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY, BONUS FROM EMPLOYEE;

DROP TABLE EMP_SALARY;

SELECT *
FROM EMP_SALARY;


-- 방명수의 급여, 보너스를 심봉선의 데이터랑 동일하게 수정하라
SELECT SALARY, BONUS 
FROM EMP_SALARY
WHERE EMP_NAME = '심봉선';

UPDATE EMP_SALARY SET SALARY = 3500000, BONUS = 0.15 WHERE EMP_NAME = '방명수';

ROLLBACK;

SELECT *
FROM EMP_SALARY;


-- 이렇게 할 수 있음 
UPDATE EMP_SALARY SET (SALARY, BONUS) = (SELECT SALARY, BONUS FROM EMPLOYEE WHERE EMP_NAME = '심봉선') WHERE EMP_NAME = '방명수';
 
 
 
-- 임시환 사원의 직급을 과장으로, 부서를 해외영업3부로 변경하는 쿼리를 작성해보자
UPDATE EMP_SALARY SET (JOB_TITLE, DEPT_TITLE) = (SELECT JOB_CODE, DEPT_TITLE 
                                                FROM EMPLOYEE 
                                                    LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
                                                         JOIN JOB USING(JOB_CODE) 
                                                WHERE JOB_TITLE = '과장' AND DEPT_TITLE = '해외영업3부') WHERE EMP_NAME = '임시환';
                                                
-- 선생님 풀이 
UPDATE EMP_SALARY SET JOB_CODE = (SELECT JOB_CODE FROM JOB WHERE JOB_CODE = '과장'),
                      DEPT_CODE = (SELECT DEPT_CODE FROM DEPARTMENT WHERE DEPT_TITLE = '해외영업3부') WHERE EMP_NAME = '임시환';
                      
-- 크로스조인 이용
UPDATE EMP_SALARY SET (JOB_CODE, DEPT_CODE) = (SELECT JOB_CODE, DEPT_ID 
                                               FROM JOB 
                                                    CROSS JOIN DEPARTMENT 
                                               WHERE JOB_TITLE = '과장' AND DEPT_TITLE = '해외영업3부') WHERE EMP_NAME = '임시환'; 
                                                                                            
-- 테이블 생성하면서 뭐가 잘못되었나봐 

SELECT *
FROM JOB 
    CROSS JOIN DEPARTMENT;
    
    
    
    
-- DELETE문
-- 조건에 맞는 ROW를 삭제하는 명령어
-- DELETE FROM 테이블명 [WHERE 조건식];
-- WHERE이 있으면 그 조건이 true인 row만 삭제, 없으면 전체 행을 삭제

SELECT *
FROM EMP_SALARY;

DELETE FROM EMP_SALARY;

SELECT *
FROM EMP_SALARY; -- 행 다 삭제되었다

ROLLBACK;

SELECT *
FROM EMP_SALARY; -- 다시 다 생겨났따


-- 보너스 없는 사원 삭제 
DELETE FROM EMP_SALARY WHERE BONUS IS NULL; -- 15개 행 삭제 

SELECT *
FROM EMP_SALARY;




-- DELETE 사용시 주의할 점 : 외래키 제약조건 -> 삭제 대상의 row가 다른테이블에서 참조되고 있으면 기본적으로 삭제 불가능
-- 옵션에 따라 삭제가능하게 변경 할 수 있다






-- TRUNCATE 
-- row(데이터)를 삭제 
-- DELETE보다 속도가 빠르지만, ROLLBACK 할 수 없다 
DELETE FROM EMP_SALARY;

SELECT *
FROM EMP_SALARY;

ROLLBACK;

SELECT *
FROM EMP_SALARY;




TRUNCATE TABLE EMP_SALARY; -- 잘렸다고 표현한다.

SELECT *
FROM EMP_SALARY;

ROLLBACK; -- 롤백 완료라고 뜨긴 뜸 

SELECT *
FROM EMP_SALARY; -- 대신 데이터가 살아나지 않음 

-- TRUNCATE를 사용하면 되돌릴 수 없으니 백업을 꼭 해야한다 






-- MERGE 
-- 두 테이블을 합칠 때 사용


-- 테스트용 테이블 생성
CREATE TABLE TBL_MERGE01(
    ID VARCHAR2(20),
    NAME VARCHAR2(20)
);


CREATE TABLE TBL_MERGE02(
    ID VARCHAR2(20),
    NAME VARCHAR2(20)
);

SELECT *
FROM TBL_MERGE01;

SELECT *
FROM TBL_MERGE02;


INSERT INTO TBL_MERGE01 VALUES('USER11', '김예진');
INSERT INTO TBL_MERGE01 VALUES('USER22', '김성원');
INSERT INTO TBL_MERGE02 VALUES('USER33', '김용대');
INSERT INTO TBL_MERGE02 VALUES('USER22', '한은주');

DELETE FROM TBL_MERGE01;
DELETE FROM TBL_MERGE02;

SELECT *
FROM TBL_MERGE01;

SELECT *
FROM TBL_MERGE02;


-- MERGE01에 다 저장하고싶어 
-- 
MERGE INTO TBL_MERGE01 USING TBL_MERGE02 ON (TBL_MERGE01.ID = TBL_MERGE02.ID)
WHEN MATCHED 
    THEN UPDATE SET TBL_MERGE01.NAME = TBL_MERGE02.NAME -- ID가 같으면 TBL_MERGE01의 NAME에 TBL_MERGE02.NAME를 넣음 
WHEN NOT MATCHED 
    THEN INSERT VALUES(TBL_MERGE02.ID, TBL_MERGE02.NAME); 

SELECT *
FROM TBL_MERGE01;  -- 22 김성원이 사라지고 22 한은주만 남음 

SELECT *
FROM TBL_MERGE02;






-------------- DDL - ALTER, DROP -------------------------


-- ALTER : 테이블에 정의된 내용을 수정 
-- 테이블 등 오라클 객체를 수정하는 명령어
-- 컬럼 추가, 컬럼 삭제, 제약조건 추가, 제약조건 삭제, 컬럼의 자료형 변경, DEFAULT값 변경, 테이블명 변경, 컬럼명 변경, 제약조건명 변경.....


--테스트용 테이블 생성
CREATE TABLE TBL_USER_ALTER(
    USER_NO NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(20),
    USER_PW VARCHAR2(20)
);

SELECT *
FROM TBL_USER_ALTER;


-- 컬럼 추가 
--ALTER TABLE 테이블명 ADD(컬럼명 타입) 
ALTER TABLE TBL_USER_ALTER ADD( USER_NAME VARCHAR2(20) 여기에 제약조건 선언 가능 );

SELECT *
FROM TBL_USER_ALTER;


INSERT INTO TBL_USER_ALTER VALUES(1, 'ADMIN', '1234', '관리자');

SELECT *
FROM TBL_USER_ALTER;


-- 기존에 데이터가 있는 상태에서 컬럼을 추가하면 ----중요 !!!!!!!!!!!!!!!!!!!!!!!!!!!!


ALTER TABLE TBL_USER_ALTER ADD( USER_NICKNAME VARCHAR2(20) );

SELECT *
FROM TBL_USER_ALTER;
-- 기존의 데이터릐 USER_NICKNAME컬럼의 값이 NULL이 되네 

ALTER TABLE TBL_USER_ALTER ADD( EMAIL VARCHAR2(50) NOT NULL ); 
-- 오류 "table must be empty to add mandatory (NOT NULL) column"
-- 테이블이 비어있어야 (데이터가 없어야) NOT NULL 제약조건을 추가할 수 있다.

DELETE FROM TBL_USER_ALTER;

ALTER TABLE TBL_USER_ALTER ADD( EMAIL VARCHAR2(50) NOT NULL ); 
-- 데이터 다 삭제하고 실행해보니까 정상적으로 컬럼이 추가되었다. 


-- 다시 데이터 삽입 
INSERT INTO TBL_USER_ALTER VALUES(1, 'ADMIN', '1234', '관리자', '관리', 'ADMIN@HOT.COM');

SELECT *
FROM TBL_USER_ALTER;

ALTER TABLE TBL_USER_ALTER ADD( AGE NUMBER NOT NULL);
-- "table must be empty to add mandatory (NOT NULL) column"

ALTER TABLE TBL_USER_ALTER ADD( AGE NUMBER DEFAULT 0 NOT NULL);
-- 정상 실행 
-- NOT NULL제약조건이 있으면 default값을 설정해주면 데이터가 있는 상태에서도 컬럼을 추가할 수 있다. 

SELECT *
FROM TBL_USER_ALTER;

INSERT INTO TBL_USER_ALTER(USER_NO, USER_ID, USER_NAME, EMAIL) VALUES(2, 'USER00', '영영', 'U00@U.COM');
-- age값을 안넣어도 삽입 가능 

SELECT *
FROM TBL_USER_ALTER;
-- age가 0으로 들어감 

INSERT INTO TBL_USER_ALTER VALUES(3, 'USER01', 'USER01', '영일', '영일영일', 'A@COM', 20);

SELECT *
FROM TBL_USER_ALTER;
-- AGE가 20으로 되었음 





-- ALTER로 제약조건 추가하기 

ALTER TABLE TBL_USER_ALTER ADD UNIQUE(USER_ID); -- 이 방법 비추 !

-- 제약조건명이 자동으로 부여되어서 구별하기 힘들기 때문 ( SYS- 어쩌고저쩌고 이런식으로 )


-- 제약조건명까지 부여하고싶으면?

ALTER TABLE TBL_USER_ALTER ADD CONSTRAINT UQ_USER_NAME UNIQUE(USER_NAME);



-- 제약조건 삭제하기 
-- ADD 대신 DROP 
-- 제약조건명으로 삭제 

ALTER TABLE TBL_USER_ALTER DROP CONSTRAINT UQ_USER_NAME;




-- 컬럼명 수정하기

ALTER TABLE TBL_USER_ALTER RENAME COLUMN USER_PW TO PASSWORD;

SELECT *
FROM TBL_USER_ALTER;



-- 제약조건명 수정하기

-- 프라이머리키의 제약조건명 변경 
ALTER TABLE TBL_USER_ALTER RENAME CONSTRAINT SYS_C007168 TO PK_TBL_USER;




-- 컬럼에 대한 타입을 변경하기 
-- MODIFY 예약어 

ALTER TABLE TBL_USER_ALTER MODIFY USER_NAME VARCHAR2(200);

DESC TBL_USER_ALTER;

-- 데이터가 이미 존재하는 상황에서 데이터크기를 줄이는건 안돼 
-- 데이터가 없으면 가능함 
ALTER TABLE TBL_USER_ALTER MODIFY USER_NAME VARCHAR2(5);
--  "cannot decrease column length because some value is too big"




-- NOT NULL 제약조건 설정 -> TBL_USER_ALTER 테이블의 USER_NAME 컬럼에 설정

ALTER TABLE TBL_USER_ALTER ADD CONSTRAINT NN_USER_NAME NOT NULL;
-- 이렇게 하는거 아냐

-- NULL에 대한 제약조건은 DEFAULT로 설정되어있기때문에 ADD로 추가하는것이 아니라 MODIFY로 수정을 해줘야함 

ALTER TABLE TBL_USER_ALTER MODIFY USER_NAME CONSTRAINT NN_USER_NAME NOT NULL;





-- 컬럼을 삭제
-- DROP

ALTER TABLE TBL_USER_ALTER DROP COLUMN USER_NAME;

SELECT *
FROM TBL_USER_ALTER;





-- 테이블명 변경

ALTER TABLE TBL_USER_ALTER RENAME TO CHANGE_TABLE;

SELECT *
FROM TBL_USER_ALTER;
-- table or view does not exist"

SELECT *
FROM CHANGE_TABLE;


-- ALTER를 꼭 써야하는것은 아님
RENAME CHANGE_TABLE TO TBL_USER_ALTER;

SELECT *
FROM TBL_USER_ALTER;




-- 아예 테이블 자체를 삭제하기
-- DROP TABLE

DROP TABLE TBL_USER_ALTER;

-- DROP TABLE할 때 주의할 점 : 다른테이블과 참조관계시(외래키로 사용하고있을 시) 테이블이 삭제되지 않음 

CREATE TABLE TBL_USER(
    EMP_ID VARCHAR2(20) REFERENCES EMP_DEP_COPY(EMP_ID)
);


ALTER TABLE EMP_DEP_COPY ADD CONSTRAINT UQ_EMP_ID UNIQUE(EMP_ID);

DROP TABLE TBL_USER;

-- DROP TABLE EMP_DEP_COPY; 
-- 이렇게 하면 삭제 안됌

-- TBL_USER 테이블이 EMP_DEP_COPY테이블의 EMP_ID컬럼을 참조하고 있으니까 

-- 그러면 방법은 2개
-- 1. 자식테이블을 삭제하고 부모테이블을 삭제한다 
-- 2. DROP TABLE 구문에 CASCADE CONSTRAINT를 추가한다 

DROP TABLE EMP_DEP_COPY CASCADE CONSTRAINT; -- 내 테이블 지울때 관계설정된 테이블도 지워버림 






--------------------------- DCL --------------------------------------------





-- DCL
-- 데이터 제어어
-- DB에 대한 보안, 무결성, 복구 등 DBMS를 제어하기 위한 명령어
-- 권한부여(GRANT, REVOKE), TCL : 트랜잭션(COMMIT, ROLLBACK)


-- GRANT : 사용자에게 권한을 부여하는 명령어 
-- GRANT 권한 또는 ROLE명칭 TO 사용자계정 [WITH ADMIN OPTION] - 이 옵션은 쓰지 말기

-- 권한 테스트
-- 사용자 생성 : DBA 로 계정 전환하고 
CREATE USER QWER IDENTIFIED BY QWER;


-- 권한부여를 이렇게 해도 된다 
-- 권한명으로 권한을 부여하는 방법 
GRANT CREATE SESSION TO QWER;


-- ROLE로 지정된 권한을 부여 
GRANT CONNECT TO QWER;


-- 사용자에게 부여된 권한을 조회
SELECT *
FROM DBA_SYS_PRIVS
WHERE GRANTEE = 'QWER';

SELECT *
FROM DBA_ROLE_PRIVS
WHERE GRANTEE = 'KH';
-- RESOURCE, CONNECT 


SELECT *
FROM ROLE_SYS_PRIVS;


-- KH로 전환하고 
SELECT *
FROM USER_ROLE_PRIVS;



-- QWER 계정에는 CREATE SESSION이라는 권한만 부여되어있음 -> 접속만 가능 
-- QWER 계정으로 테이블 생성하려고 하면 에러 
CREATE TABLE TEST(
    NAME VARCHAR2(20)
);

-- DROP TABLE TEST;

-- DBA로 전환하고 
-- 테이블 생성할 수 있는 권한 
GRANT CREATE TABLE TO QWER;
-- TABLESPACE에 대한 영역 확보  
ALTER USER QWER DEFAULT TABLESPACE USERS;


-- QWER로 전환하고 생성하면 가능하다! 
CREATE TABLE TEST(
    NAME VARCHAR2(20)
);

-- DBA로 
SELECT *
FROM DBA_SYS_PRIVS
WHERE GRANTEE = 'CONNECT';

SELECT *
FROM DBA_SYS_PRIVS
WHERE GRANTEE = 'RESOURCE';




-- 권한을 부여해서 다른 계정에 있는 테이블을 이용하게 만들기 

-- QWER 계정으로 
SELECT * 
FROM KH.DEPARTMENT;

-- DBA 계정으로
GRANT SELECT ON KH.DEPARTMENT TO QWER;

-- QWER 계정으로 
SELECT * 
FROM KH.DEPARTMENT;
-- 접근 가능해졌다!

INSERT INTO KH.DEPARTMENT VALUES('K2', '개발지원부', 'L3');
-- 에러
-- 위에서 SELECT문만 사용할 수 있게 권한을 부여했기 때문에 INSERT는 안된다

-- DBA 계정으로 권한 부여 
GRANT INSERT ON KH.DEPARTMENT TO QWER;

-- QWER 계정으로
INSERT INTO KH.DEPARTMENT VALUES('K2', '개발지원부', 'L3');
-- 삽입 가능해졌다 

-- KH계정으로
SELECT *
FROM DEPARTMENT;
-- 개발지원부가 없네?! 
-- 트랜잭션 때문 -> insert update delete에 대해 commit 해야만 다른 계정으로도 볼 수 있음 

-- QWER 계정으로
COMMIT;

-- KH계정으로
SELECT *
FROM DEPARTMENT;
-- 개발 지원부가 생겼다 


-- 권환 회수
-- REVOKE

-- DBA 계정으로
REVOKE INSERT ON KH.DEPARTMENT FROM QWER;

INSERT INTO KH.DEPARTMENT VALUES('K3', '개발지원부3', 'L3');

-- QWER 계정으로
INSERT INTO KH.DEPARTMENT VALUES('K4', '개발지원부4', 'L3');
-- 권한 회수해서 삽입 불가 


-- 한꺼번에 권한 부여
GRANT INSERT, SELECT, UPDATE, DELETE ON KH.DEPARTMENT TO QWER;

-- 한꺼번에 권한 회수 
REVOKE INSERT, SELECT, UPDATE, DELETE ON KH.DEPARTMENT TO QWER;




-- 트랜잭션 : 작업의 논리적인 단위 
-- INSERT, UPDATE, DELETE 즉 테이블에 데이터를 조작할 때 트랜잭션을 사용 

-- KH 계정으로
SELECT *
FROM TBL_USER;


INSERT INTO TBL_USER VALUES('USER01');
INSERT INTO TBL_USER VALUES('USER02');
INSERT INTO TBL_USER VALUES('USER03');
-- 안된다..

-- DBA 계정에서 이 테이블을 보면 
SELECT *
FROM KH.TBL_USER;

-- 위의 3개의 데이터를 삽입하고 DBA계정에서 보면 없다. 
-- KH계정으로 COMMIT하고 테이블을 보면 데이터가 있다. 



SELECT *
FROM MEMBER;












