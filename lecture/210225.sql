
--0225

-- 배운 내용 : IN-LINE VIEW, TOP-N분석, DDL




-- IN-LINE VIEW
-- FROM절에 서브쿼리 넣는 것 

-- 사원명, 부서명, 직책명, 급여, 보너스, 성별 
SELECT EMP_NAME, DEPT_TITLE, JOB_NAME, SALARY, BONUS, DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여')
FROM EMPLOYEE 
    JOIN DEPARTMENT ON DEPT_ID = DEPT_CODE
    JOIN JOB USING(JOB_CODE)
WHERE DEPT_CODE = 'D6';

SELECT *
FROM (
    SELECT EMP_NAME AS 사원명, DEPT_CODE AS 부서코드, DEPT_TITLE AS 부서명, JOB_NAME AS 직책명, SALARY AS 급여, BONUS AS 보너스, DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') AS 성별 
    FROM EMPLOYEE 
        JOIN DEPARTMENT ON DEPT_ID = DEPT_CODE
        JOIN JOB USING(JOB_CODE)
    WHERE DEPT_CODE IN ('D5', 'D6')
    )
-- WHERE절에서는 위의 FROM안에 있는 컬럼들만 사용할 수 있다.
--WHERE EMP_NAME = '송종기';
--WHERE 사원명 = '송종기';
-- 별칭으로 접근 가능
--WHERE 사원명 = '유재식';
WHERE 부서명 LIKE '%해외%';




-- TOP-N 분석 : ROW에 순서를 매기는것 -> Paging 처리 
-- 급여를 가장 많이 받는 3명의 사원
-- 댓글이 가장 많은 10개
-- 좋아요 많은 5개 게시글 

-- 2가지 방법
-- 1. ROWNUM : 오라클이 기본으로 제공하는 컬럼 -> 모든테이블에 자동으로 설정
-- row의 순서값을 가지고 있다. 
-- 2. 함수 이용 : 오라클이 제공하는 TOP이라는 함수 

-- 방법1 사용
SELECT ROWNUM
FROM EMPLOYEE;

SELECT ROWNUM, E.*
FROM EMPLOYEE E;

SELECT ROWNUM, E.*
FROM EMPLOYEE E
WHERE ROWNUM BETWEEN 1 AND 10;

-- ROWNUM을 이용할 때 문제가 발생한다 삐요 삐요 
-- 급여를 가장 많이 받는 3명의 사원을 조회
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE (ROWNUM BETWEEN 1 AND 3) 
ORDER BY SALARY DESC;

SELECT EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC;

-- ROWNUM은 FROM절로 테이블을 가져올 때 순서를 부여함 

-- 풀었당!!!!! ><
SELECT ROWNUM, EMP_NAME, SALARY
FROM (
    SELECT EMP_NAME, SALARY
    FROM EMPLOYEE
    ORDER BY SALARY DESC
    )
WHERE ROWNUM BETWEEN 1 AND 3;


-- 선생님 풀이
SELECT ROWNUM, E.*
FROM ( SELECT ROWNUM AS 내부, EMP_NAME, SALARY
        FROM EMPLOYEE
        ORDER BY SALARY DESC) E;

-- FROM 이 있을때마다 (테이블을 불러올때마다) ROWNUM이 새로 부여된다.

-- 월급이 제일 높은 10명
SELECT EMP_NAME, SALARY
FROM (
    SELECT EMP_NAME, SALARY
    FROM EMPLOYEE
    ORDER BY SALARY DESC
    )
WHERE ROWNUM BETWEEN 1 AND 10;

SELECT EMP_NAME, SALARY
FROM (
    SELECT *
    FROM EMPLOYEE
    ORDER BY SALARY ASC
    )
WHERE ROWNUM BETWEEN 1 AND 10;

-- 무조건 인라인뷰로 가져오는 테이블에 있는 컬럼만 SELECT에서 사용할 수 있다. 

-- D5 부서의 연봉을 많이 받는 사람 3명
SELECT EMP_NAME AS 사원명, DEPT_CODE AS 부서코드, SALARY*12 AS 연봉 
FROM (
    SELECT *
    FROM EMPLOYEE
    ORDER BY SALARY*12 DESC
    
    )
WHERE DEPT_CODE = 'D5' AND ROWNUM BETWEEN 1 AND 5;

-- 선생님 풀이 
SELECT 사원명, 부서코드, 연봉
FROM (
    SELECT EMP_NAME AS 사원명, DEPT_CODE AS 부서코드, SALARY*12 AS 연봉 
    FROM EMPLOYEE
    ORDER BY SALARY*12 DESC
    
    )
-- WHERE DEPT_CODE = 'D5' AND ROWNUM BETWEEN 1 AND 5;
WHERE 부서코드 = 'D5' AND ROWNUM BETWEEN 1 AND 5;
-- 이미 FROM안에서 컬럼이름을 별칭을 바꿔버렸기 때문에, 원래 컬럼명으로 접근할 수 없다. 


SELECT EMP_NAME AS 사원명, DEPT_TITLE AS 부서명, SALARY*12 AS 연봉 
FROM (
    SELECT *
    FROM EMPLOYEE
        JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    ORDER BY SALARY*12 DESC
    )
WHERE DEPT_CODE = 'D5' AND ROWNUM BETWEEN 1 AND 5;


-- 사원 급여를 4번째에서 8번째로 많이 받은 사원의 이름, 급여 조회 
SELECT ROWNUM, EMP_NAME, SALARY
FROM (
    SELECT *
    FROM EMPLOYEE
    ORDER BY SALARY DESC
    )
WHERE ROWNUM BETWEEN 4 AND 8;
-- ROWNUM은 중간부터 체크할 수가 없어 


-- 정말 중요 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
SELECT ROWNUM, A.*

FROM (
    -- 급여로 내림차순 정렬해놓은 데이터에 부여된 rownum을 중간부터 사용하기 위해서는 컬럼으로 지정해서 사용할 필요가 있다. 
    -- 그래서 이렇게 SELECT문에서 컬럼으로 지정해서 이 rownum으로 순위를 매긴다 
    SELECT ROWNUM AS RNUM, E.*
    
    FROM (
        SELECT EMP_NAME, SALARY
        FROM EMPLOYEE
        ORDER BY SALARY DESC
        ) E
        
    ) A
    
WHERE RNUM BETWEEN 4 AND 8;
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!



-- 방법2 함수를 이용해서 순위를 매기는 방법
-- RANK() OVER(정렬기준) 
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) AS 순위
FROM EMPLOYEE;

SELECT *
FROM (
    SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) AS 순위
    FROM EMPLOYEE
    )
WHERE 순위 BETWEEN 1 AND 3;



SELECT *
FROM (
    SELECT EMP_NAME, SALARY, 
            RANK() OVER(ORDER BY SALARY DESC) AS 순위, 
            -- PARTITION BY : 더 세부적인 범위를 나눠서 순위를 매기고 싶을 때 
            RANK() OVER(PARTITION BY DEPT_CODE ORDER BY SALARY DESC) AS "부서별 순위",
            RANK() OVER(PARTITION BY JOB_CODE ORDER BY SALARY DESC) AS "직책별 순위"
    FROM EMPLOYEE
    )
WHERE 순위 BETWEEN 1 AND 3;



-- DENSE_RANK() OVER : 중복된 순위가 있을 때 번호를 부여해서 차이가 난다
-- 빈값이 없게끔 15가 두번 중복되어도 16이 있게 끔 한다
-- RANK OVER는 16이 없고 17이 나오는 식

-- 4순위가 중복되어서 5순위가 없어졌어 
SELECT RANK() OVER(ORDER BY SALARY) AS 순위,
        EMP_NAME, SALARY
FROM EMPLOYEE;

-- 4순위가 중복되어도 5순위가 있어
SELECT DENSE_RANK() OVER(ORDER BY SALARY) AS "DENSE 순위", EMP_NAME, SALARY
FROM EMPLOYEE;

SELECT 
    RANK() OVER(ORDER BY SALARY) AS 순위, EMP_NAME, SALARY,
    DENSE_RANK() OVER(ORDER BY SALARY) AS "DENSE 순위"
FROM EMPLOYEE
WHERE RANK() OVER(ORDER BY SALARY) BETWEEN 1 AND 3;
-- 랭크 함수는 WHERE절에 쓸 수 없다 - window함수라서 
-- resultset에 순서를 부여하는것이었다. 



-- 계층형 쿼리 
-- 댓글 조회할때 사용 
-- !!!!!!!!!!!!!!!!!!!!!!! 중요 !!!!!!!!!!!!!!!!!!!!!!!!!!!
-- 수직적인 관계를 표현할 때 사용 -> 조직도, 메뉴, 답변형 게시판(댓글)
SELECT LEVEL, EMP_ID, EMP_NAME, MANAGER_ID
FROM EMPLOYEE
    START WITH EMP_ID = 200 -- 계층의 시작기준(root) : LEVEL컬럼을 부여하는 기준 
    CONNECT BY PRIOR EMP_ID = MANAGER_ID; -- 관계 연결 기준 
    -- ORDER BY LEVEL; 잘 쓰지 않는다 
    
-- LEVEL도 ROWNUM처럼 오라클에서 기본으로 제공하는 컬럼
-- LEVEL : 계층의 정보, 


-- 보기 편하게
SELECT LEVEL || ' ' || LPAD(' ', (LEVEL-1)*5, ' ') || EMP_NAME || NVL2(MANAGER_ID, '(' || MANAGER_ID || ')', '') AS 조직도
FROM EMPLOYEE 
    START WITH MANAGER_ID IS NULL --> 매니저 없는 사람도 출력된다 
    -- START WITH EMP_ID = 200 -- -> 매니저가 없는 사람은 출력되지 않는다 
    CONNECT BY PRIOR EMP_ID = MANAGER_ID;



---------------------------------- DDL -------------------------------------

-- 데이터 타입
-- 문자형 : CHAR, VARCHAR2, NCHAR, NVARCHAR2
-- CHAR(길이) : 고정형 문자열 타입, ()안의 길이만큼 공간을 확보하여 사용, 최대 2000바이트 사용, 한글은 3바이트 
-- VARCHAR2 : 가변형 문자열 타입, 길이만큼 공간을 확보할 수 있다. 대입된 데이터만큼만 사용, 최대 4000바이트 사용
-- CHAR(10), VARCHAR2(10)
-- '김예진', '김예진' -> 9바이트여도 CHAR형은 무조건 10바이트 반영, VARCHAR2는 들어온 데이터만큼 반영 -> 9바이트 반영 

CREATE TABLE TBL_DATA_STR(
    -- CHAR, VARCHAR2 는 (바이트수)
    A CHAR(6),
    B VARCHAR2(6), -- 권장 
    --  NCHAR, NVARCHAR2 는 (글자수)
    -- 한글자당 2바이트 
    C NCHAR(6),
    D NVARCHAR2(6)
);

SELECT *
FROM TBL_DATA_STR;

INSERT INTO TBL_DATA_STR
    VALUES('ABC', 'ACB', 'ABC', 'ABC');
    
SELECT LENGTH(A), LENGTH(B), LENGTH(C), LENGTH(D)
FROM TBL_DATA_STR;

INSERT INTO TBL_DATA_STR
    VALUES('가나', '가', '가나다', '가나');

SELECT *
FROM TBL_DATA_STR;

-- LENGTH 
SELECT LENGTH(A), LENGTH(B), LENGTH(C), LENGTH(D)
FROM TBL_DATA_STR;

-- LENGTHB - 
-- CHAR, VARCHAR2 - 바이트수, NCHAR, NVARCHAR2 - 글자수 
SELECT LENGTHB(A), LENGTHB(B), LENGTHB(C), LENGTHB(D)
FROM TBL_DATA_STR;

INSERT INTO TBL_DATA_STR
    VALUES('가', '가', '가나다', '가나');


CREATE TABLE PERSON(
    NAME VARCHAR2(10) -- 이름 글자수 제한 -> 3글자 ( 잘 생각해서 정해야함) 
);



-- LONG 타입 : 2GB -> 사용하지 말라고 오라클이 정해둠 
-- CLOB : 4GB ->  문자열의 길이가 크면 (4000바이트 이상) 이것을 사용

-- 숫자형 : NUMBER
-- 실수와 정수 모두 NUMBER에 저장 
-- NUMBER(PRECISION, SCALE)
-- PRECISION : 표현할 수 있는 전체 자료수(1~ 38)
-- SCLAE : 소수점 이하 자리수 ( -84 ~ 127)
-- PRECISION, SCALE는 둘다 생략가능
CREATE TABLE TBL_DATA_NUM (
    A NUMBER,
    B NUMBER(5),  -- 소수점을 제거하고싶을땐 이렇게 
    C NUMBER(5,1),
    D NUMBER(5, -2)
);
 
SELECT *
FROM TBL_DATA_NUM;

-- 데이터타입에 맞춰서 자동으로 반올림한다
INSERT INTO TBL_DATA_NUM VALUES(1234.567, 1234.567, 1234.567, 1234.567);





-- 날짜형 : DATE
-- 데이터형 : BLOB, CLOB

CREATE TABLE TBL_DATA_DATE(
    BIRTHDAY DATE 
);

SELECT *
FROM TBL_DATA_DATE;

INSERT INTO TBL_DATA_DATE VALUES('93/07/10');

SELECT *
FROM TBL_DATA_DATE;

INSERT INTO TBL_DATA_DATE VALUES(TO_DATE(199307130945, 'YYYYMMDDHHMI'));

SELECT *
FROM TBL_DATA_DATE;




-- 기본테이블 생성하기
-- CREATE 명령어
-- CREATE TABLE 테이블명(컬럼선언 : 컬럼명 자료형 )
CREATE TABLE MEMBER(
    MEMBER_ID VARCHAR2(20),
    MEMBER_PW VARCHAR2(20),
    MEMBER_NAME VARCHAR2(20)
);

SELECT *
FROM MEMBER;
-- 접속 -> KH -> 테이블 확인 가능 
-- COLUMN_ID : 인덱스번호 

-- 테이블의 컬럼에 코멘트 달기 
COMMENT ON COLUMN MEMBER.MEMBER_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER.MEMBER_PW IS '회원비밀번호';
COMMENT ON COLUMN MEMBER.MEMBER_NAME IS '회원이름';


-- 전체 테이블의 commnet 확인하기
SELECT * 
FROM USER_COL_COMMENTS;

-- MEMBER 테이블의 commnet 확인 
SELECT * 
FROM USER_COL_COMMENTS
WHERE TABLE_NAME = 'MEMBER';

-- 테이블에 comment 달기 
COMMENT ON TABLE MEMBER IS '회원정보관리';

SELECT *
FROM USER_TAB_COMMENTS;


-- 테이블 삭제
-- DROP TABLE 테이블명;
DROP TABLE TBL_DATA_DATE;


DROP TABLE TBL_DATA_STR;


















