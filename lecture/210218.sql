-- 0218 목요일
CREATE USER TEST IDENTIFIED BY TEST;
-- RESOURCE, CONNECT ->
-- RESOURCE 테이블을 생성, 조작할 수 있는 권한 
-- CONNECT 할당된 영역에 접속할 수 있는 권한
GRANT RESOURCE, CONNECT TO TEST;

-- 계정 정보 확인하기
SELECT * FROM TAB; -- 계정이 가지고 있는 전체 테이블을 조회 ( 6개 )

-- 생성된 KH계정의 테이블을 확인해보자 ( 테이블 이름(TNAME)으로 조회)

SELECT * FROM DEPARTMENT; -- 테이블을 하나하나 실행

SELECT * FROM EMPLOYEE;

SELECT * FROM JOB;

SELECT * FROM LOCATION;

SELECT * FROM NATIONAL;

SELECT * FROM SAL_GRADE;

-- KH 계정의 EMPLOYEE 테이블을 조회해보자
-- 사번 (EMP_ID), 이름(EMP_NAME), 월급(SALARY) 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 사원 이름, 이메일, 부서코드, 직책 코드를 조회
SELECT EMP_NAME, EMAIL, DEPT_CODE, JOB_CODE
FROM EMPLOYEE;

-- EMPLOYEE 테이블에 있는 전체 컬럼을 조회
SELECT EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY, BONUS, MANAGER_ID, HIRE_DATE, ENT_DATE, ENT_YN
FROM EMPLOYEE;

-- 너무 귀찮다! 전체 조회를 할 때는 * 을 사용하자
SELECT *
FROM EMPLOYEE;

-- SELECT문은 조회뿐만 아니라 조회할 때 산술연산처리도 가능하다
-- 단 산술연산은 숫자타입을 계산해야한다
-- SELECT 컬럼명 또는 리터럴
SELECT 10*100
FROM DUAL; -- DUAL테이블은 오라클에서 기본으로 제공하는 테이블로, 간단한 테스트를 위한 테이블이다

-- SELECT문에서 산술연산을 할 때는 컬럼명을 가져와서 계산할 수도 있다
SELECT * 
FROM EMPLOYEE;

-- 사원의 연봉을 구하자
SELECT EMP_NAME, SALARY, SALARY*12
FROM EMPLOYEE;

-- 각 사원의 보너스를 구하자
SELECT EMP_NAME,SALARY, BONUS, SALARY*BONUS
FROM EMPLOYEE;

-- 컬럼값이 Null인 Row는 값이 없는것이라서 쓰레기다. -> 계산을 할 수 없다

-- EMPLOYEE 테이블에서 사원명, 부서코드, 직책코드, 월급, 연봉, 보너스포함연봉 조회하기
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, SALARY, SALARY*12, SALARY*BONUS*12
FROM EMPLOYEE;

SELECT EMP_NAME, DEPT_CODE, JOB_CODE, SALARY, SALARY*12, (SALARY+(SALARY*BONUS))*12
FROM EMPLOYEE;

-- RESULTSET의 컬럼명 변경하기 (별칭부여)(실질적인 컬럼명이 바뀌는것은 아니다)
-- 컬럼명 AS 별칭명 또는 컬럼명 AS 별칭 (가독성을 위해 전자를 사용하는것을 추천한다)
SELECT EMP_NAME, EMAIL, PHONE
FROM EMPLOYEE;

SELECT EMP_NAME AS 사원명, EMAIL AS 이메일, PHONE AS 전화번호
FROM EMPLOYEE;

-- 그러면 별칭은 아무거나 다 사용이 가능한가? 띄어쓰기나 특수기호도 쓸 수 있나?
-- 특수기호, 첫글자 숫자, 띄어쓰기를 사용할 때는 ""으로 감싸야한다
-- ""로 감싼것은 문자열 리터럴이 아니다 ( 자바랑 다른점 ) 
-- 문자열 리터럴 : ''로 감싼다
SELECT EMP_NAME AS "사 원 명", EMAIL AS "@이메일", -- 띄어쓰기 불가, 특수기호도 안되네  -> ""안에 적은 공백과 특수기호는 가능
        DEPT_CODE AS "1부서"
FROM EMPLOYEE;

-- SELECT절에서 문자열리터럴 사용하기
SELECT EMP_NAME, '님',  SALARY, '원'
FROM EMPLOYEE;

-- 행row에서 중복값을 제거하고 출력하기
-- DISTINCT : 중복된 행의 값을 하나만 출력
SELECT JOB_CODE
FROM EMPLOYEE;

SELECT DISTINCT JOB_CODE
FROM EMPLOYEE; -- JOB_CODE 출력할 때 중복되는 값을 하나만 출력

SELECT DISTINCT JOB_CODE, DEPT_CODE -- 두 컬럼을 한개로 합쳐서 인식한다. -> 합친것을 한개씩만 출력
FROM EMPLOYEE; -- DISTINCT는 SELECT문에서 한번만 사용할 수 있다. 주의)SELECT문의 맨 앞에 작성해야한다.

-- 컬럼 혹은 리터럴을 연결해보자
-- || 연산자 : SELECT뒤에 작성된 컬럼 혹은 리터럴을 한개의 컬럼으로 합쳐주는 기능
SELECT EMP_NAME, '님', SALARY, '원'
FROM EMPLOYEE;

SELECT EMP_NAME||'님', SALARY||'원'
FROM EMPLOYEE;

SELECT EMP_NAME||'님'||SALARY||'원'
FROM EMPLOYEE;

SELECT EMP_NAME||'님'||SALARY||'원', DEPT_CODE||JOB_CODE AS 부서직책
FROM EMPLOYEE;

-- 지금까지 SELECT 컬럼명, 컬럼명, 리터럴..
--        FROM 테이블명 
-- 지금부터 [WHERE 컬럼명 비교연산자(=, >=, <=, >, <, != ) 컬럼명 또는 리터럴] : 조건문(row(데이터)를 필터링 해주는 문장)
-- <비교연산자>
-- = : 동등비교(같다)
-- !=, <>, ^= : 동등비교부정(같지 않다)
-- >=, <=, >, < : 숫자 또는 날짜의 대소 비교
-- BETWEEN 숫자 AND 숫자 : 특정 범위의 값을 비교
-- LIKE / NOT LIKE : 특정패턴에 의해 값을 비교 ( 부분일치 여부 )
-- IN / NOT IN : 다중값의 포함여부를 비교(약간의 논리연산) A IN 10, 20, 30
-- IS NULL / IS NOT NULL : NULL값에 대한 비교 

-- <논리연산자>
-- 논리연산자 : 진위여부를 확인하는 연산자 : AND, OR
-- AND : 그리고 ( && 과 동일한 기능 )
-- OR : 또는 (|| 와 동일한 기능)
-- NOT : 부정연산

SELECT EMP_NAME, SALARY
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 월급이 350만원 이상인 직원만 조회
-- 사원명, 부서코드, 급여
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3500000; -- 반복문처럼 돌면서 조건에 맞는 row만을 출력한다.

-- EMPLOYEE 테이블에서 월급이 350만원 이상이면서 부서코드가 D5인 직원 조회
-- 사원명, 부서코드, 급여
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3500000 AND DEPT_CODE = 'D5';

-- 부서코드가 D6이 아닌 사원의 전체 컬럼 조회
SELECT *
FROM EMPLOYEE
-- WHERE DEPT_CODE != 'D6'; 또는
-- WHERE DEPT_CODE <> 'D6'; 또는
WHERE NOT DEPT_CODE = 'D6';

-- 직급코드가 J1이 아닌 사원의 SAL_LEVEL을 중복없이 출력
SELECT DISTINCT SAL_LEVEL
FROM EMPLOYEE
WHERE JOB_CODE != 'J1';

-- 부서코드가 D5이거나 급여가 300만원 이상 받는 사원을 조회
-- 이름, 부서코드, 급여
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' OR SALARY >= 3000000;

-- 급여가 200만원 이상, 400만원 이하인 사원의 사원명, 직책코드, 급여를 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 2000000 AND SALARY <= 4000000;

-- 범위를 조회할 때 BETWEEN AND 라는 것을 사용할 수 있다 
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY BETWEEN 2000000 AND 4000000;

-- 날짜도 대소비교를 할 수 있다
-- 날짜는 문자열로 '년/월/일' -> '00/00/00' 형식으로 작성

-- EMPLOYEE 테이블에서 고용일이 00년 01월 01일 보다 빠른 사원을 조회
SELECT *
FROM EMPLOYEE
WHERE HIRE_DATE < '00/01/01'; -- 혹시 맥에서 안될경우 '일/월/년' -> '01/JAN/00'

-- LIKE : 패턴에 의해서 데이터를 조회하는 기능
-- WHERE 컬럼명 LIKE '%리%터_럴_' 

-- % : 글자가 0개 이상(없어도 되고 개수 상관없음) 아무문자 다 허용 -> '%강%' : 데이터에 '강'이 포함되어 있는지 
--       가나다라강, 강, 가나강다라마, 강하나둘셋 ok
-- '%강' : 강으로 끝나는 글자, '강%' : 강으로 시작하는 글자
-- _ : 그 자리의 아무 글자나 한 개
-- '_강' : 강으로 끝나는 두자리의 글자
-- '___' : 세글자짜리 문자

-- EMPLOYEE 테이블에서 '전'씨 성을 가진 사원을 조회해라
SELECT *
FROM EMPLOYEE
-- WHERE EMP_NAME LIKE '전%'; 또는 
WHERE EMP_NAME LIKE '전_%';

-- 이름에 옹이 들어가는 사원의 사원명, 부서코드 조회
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '_옹%';

SELECT EMP_NAME, EMAIL
FROM EMPLOYEE
 WHERE EMAIL LIKE '___\_%' ESCAPE '\'; 또는
-- WHERE EMAIL LIKE '___\#%' ESCAPE '#';

-- 성이 이씨가 아닌 사원을 조회 
-- 사원명, 이메일
SELECT EMP_NAME, EMAIL
FROM EMPLOYEE
-- WHERE EMP_NAME NOT LIKE '이_%'; 또는
WHERE NOT EMP_NAME LIKE '이_%';

-- NULL을 비교해보자
-- BONUS 가 NULL인 사원을 출력
SELECT EMP_NAME, BONUS
FROM EMPLOYEE
-- WHERE BONUS = (null); null은 연산불가
-- null을 비교하기 위해서는 오라클에서 제공하는 예약어를 사용한다
-- IS NULL / IS NOT NULL
WHERE BONUS IS NULL;

SELECT EMP_NAME, BONUS
FROM EMPLOYEE
WHERE BONUS IS NOT NULL;

-- 다중값을 비교하기
-- IN / NOT IN : 다중값을 한번에 동등비교
-- EMPLOYEE 테이블에서 부서코드가 D5, D6인 사원 조회하기
SELECT *
FROM EMPLOYEE
-- WHERE DEPT_CODE IN ('D5', 'D6'); -- 다중행 서브쿼리와 같이 사용

-- WHERE DEPT_CODE IN ( SELECT DEPT_DOCE FROM EMPLOYEE WHRER EMP_NAME LIKE '전%');
WHERE DEPT_CODE NOT IN ('D5', 'D6');


-- 직책이 J2 또는 j7인 사원 중 급여가 200만원 보다 많은 사원 조회
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
-- WHERE JOB_CODE = 'J2' OR JOB_CODE = 'J7'  AND SALARY >= 2000000; // 틀림
WHERE (JOB_CODE = 'J2' OR JOB_CODE = 'J7') AND SALARY >= 2000000;

CREATE USER SCOOT IDENTIFIED BY TIGER;
GRANT RESOURCE, CONNECT TO SCOOT;
