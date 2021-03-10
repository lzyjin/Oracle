
-- 0223
-- SELECT문의 순서를 정렬하는 예약어
-- ORDER BY 

-- SELECT 컬럼... -> COLUMN 필터링
-- FROM 테이블명
-- [WHERE 비교연산, 논리연산 ...] : ROW를 필터링
-- [ORDER BY 컬럼명...] : 특정 컬럼을 기준으로 순서를 정렬하는것 (오름차순, 내림차순)

-- ASC / DESC 
-- ASC : 오름차순 정렬 (작은 수 -> 큰 수 | 사전순 A -> Z, ㄱ-> ㅎ | 날짜가 빠른-> 나중(NULL은 맨 나중에))
-- DESC  : 내림차순 정렬 (큰 수 -> 작은 수 | 사전 역순 Z -> A, ㅎ -> ㄱ | 날짜가 늦은 -> 빠른 (NULL은 맨 위로))

-- 사원이름으로 오름차순 정렬
SELECT EMP_NAME, SALARY, BONUS, HIRE_DATE
FROM EMPLOYEE
ORDER BY EMP_NAME ASC;

SELECT EMP_NAME, SALARY, BONUS, HIRE_DATE
FROM EMPLOYEE
ORDER BY SALARY DESC;

-- DEFAULT는 오름차순 정렬
SELECT EMP_NAME, SALARY, BONUS, HIRE_DATE
FROM EMPLOYEE
ORDER BY BONUS;

SELECT EMP_NAME, SALARY, BONUS, HIRE_DATE
FROM EMPLOYEE
ORDER BY BONUS DESC;

SELECT EMP_NAME, SALARY, BONUS, HIRE_DATE
FROM EMPLOYEE
ORDER BY HIRE_DATE;

-- ORDER BY문은 여러개 작성 가능
SELECT EMP_NAME, SALARY, BONUS, HIRE_DATE
FROM EMPLOYEE
ORDER BY SALARY DESC, EMP_NAME ASC;

-- ORDER BY구문에 SELECT구문에 작성한 컬럼을 인덱스번호(숫자)로 부를수 있음
SELECT EMP_NAME, SALARY, BONUS, HIRE_DATE
FROM EMPLOYEE
ORDER BY 1;

SELECT EMP_NAME, DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여')
FROM EMPLOYEE
ORDER BY 2;

-- ORDER BY문에 별칭 사용이 가능할까? 
-- SELECT 에서 AS를 사용하기 전에 where이 먼저실행되므로 에러!
-- 별칭은 나중에 부여됌
SELECT EMP_NAME AS 사원
FROM EMPLOYEE
WHERE 사원 LIKE '%김%';

-- 이렇게 작성하면 별칭에 있는 값에 접근 가능
-- FROM -> WHERE (ROW 필터링) -> SELECT -> ORDER BY
SELECT EMP_NAME AS 사원
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%하%'
ORDER BY 사원;




-- 그룹함수
-- RESULTSET이 한 행만 나오는 함수
-- 그룹함수는 집계함수(합계, 평균, 개수, 최대값, 최소값 같은것들)
-- 결과가 단 하나가 된다

-- SUM : 컬럼의 총 합 (NUMBER형)

-- 월급의 총합을 구하세요
SELECT SUM(SALARY)
FROM EMPLOYEE;

SELECT SUM(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6';

-- 에러
-- 결과의 개수가 다르기 때문에 그룹함수는 다른 컬럼과 함께 쓸 수 없다
SELECT EMP_NAME, SUM(SALARY)
FROM EMPLOYEE;

-- AVG : 평균
SELECT TO_CHAR(FLOOR(AVG(SALARY)), 'L999,999,999') AS "급여의 평균"
FROM EMPLOYEE;

SELECT TO_CHAR(FLOOR(AVG(SALARY)), '999,999,999') AS "급여의 평균"
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

-- COUNT : ROW의 개수를 알려주는 함수
-- JAVA의 컬렉션의 size()와 동일
SELECT COUNT(*)
FROM EMPLOYEE;

-- 사원중 직책이 J6인 사원의 수는?
SELECT COUNT(*)
FROM EMPLOYEE
WHERE JOB_CODE = 'J6';

-- 컬럼명을 적어도 된다.
SELECT COUNT(EMP_NAME)
FROM EMPLOYEE;

-- 컬럼에 있는  NULL값을 제외하고 개수를 센다
SELECT COUNT(BONUS)
FROM EMPLOYEE;

SELECT COUNT(*), COUNT(BONUS), SUM(SALARY), AVG(SALARY)
FROM EMPLOYEE;

-- MAX / MIN : 최대값 최소값
SELECT MAX(SALARY), MIN(SALARY)
FROM EMPLOYEE;
-- +  WHERE절로 더 필터링 할 수 도 있어

-- 부서가 D5, D6, D7인 사원 중 가장 월급이 많은 사람의 월급은?
SELECT MAX(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D6', 'D7');




-- GROUP BY 

-- 부서별 가장 높은 급여는?
-- NULL도 하나의 부서로 보네.
SELECT DEPT_CODE, MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- NULL을 제외하고 
SELECT DEPT_CODE, MAX(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE; 

-- 부서별 급여 평균은?
-- 그룹으로 묶은 컬럼과 상관없는 컬럼을 SELECT문에 넣으면 에러가 나요.
SELECT DEPT_CODE, FLOOR(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 직책별 급여 합계는?
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY 1;

-- 직책별 사원 인원수 구하기
SELECT JOB_CODE, COUNT(JOB_CODE)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY 1;

-- 직책별 보너스를 받는 사원의 수
SELECT JOB_CODE, COUNT(BONUS)
FROM EMPLOYEE
WHERE BONUS IS NOT NULL
GROUP BY JOB_CODE;

SELECT JOB_CODE, COUNT(*)
FROM EMPLOYEE
WHERE BONUS IS NOT NULL
GROUP BY JOB_CODE;

SELECT *
FROM EMPLOYEE;

-- GROUP BY 절에는 한개 이상의 컬럼을 사용할 수 있다.
SELECT DEPT_CODE, JOB_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE -- 이 두 컬럼을 묶어서 하나의 그룹으로. 
ORDER BY 1, 2;

-- 부서별 성별 인원수를 구하기
-- SELECT문에 COUNT를 이렇게 따로 적어야한다. 
SELECT DEPT_CODE, 
                        CASE 
                            WHEN SUBSTR(EMP_NO, 8, 1) = '1' THEN '남' 
                            ELSE '여' 
                        END AS 성별
                        , COUNT(*) 
 --SELECT DEPT_CODE, DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여' ) AS 성별, COUNT(*) 
FROM EMPLOYEE 
-- GROUP BY DEPT_CODE, DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여' )--CASE WHEN SUBSTR(EMP_NO, 8, 1) = '1' THEN '남' ELSE '여' END 
GROUP BY DEPT_CODE, CASE WHEN SUBSTR(EMP_NO, 8, 1) = '1' THEN '남' ELSE '여' END 
ORDER BY 1, 2;

-- 부서별 급여 평균이 300만원 이상인 부서들에 대해 부서명, 부서 평균을 출력
-- 그룹함수의 조건식을 작성할 때는 WHERE을 사용하지 못한다.
SELECT DEPT_CODE AS 부서명, FLOOR(AVG(SALARY)) AS "부서별 급여 평균"
FROM EMPLOYEE
WHERE FLOOR(AVG(SALARY)) >= 3000000
GROUP BY DEPT_CODE;

-- 그룹함수를 조건으로 사용할 때에는 HAVING을 이용
SELECT DEPT_CODE AS 부서명, FLOOR(AVG(SALARY)) AS "부서별 급여 평균"
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING FLOOR(AVG(SALARY)) >= 3000000;

-- 부서별 사원수가 3명 초과인 부서 출력하기
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(DEPT_CODE) > 3;

-- 매니저가 관리하는 사원이 2명 이상인 매니저아이디와 사원수 출력하기
-- 매니저가 관리 : 매니저 아이디가 동일

SELECT *
FROM EMPLOYEE;

SELECT MANAGER_ID, COUNT(*)
FROM EMPLOYEE
WHERE MANAGER_ID IS NOT NULL
GROUP BY MANAGER_ID
HAVING COUNT(MANAGER_ID) > 1;


-- 합계, ROW와 같이 나오는 합계
-- group별 합계, 총합계까지 같이
-- ROLLUP / CUBE

SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 이 경우에는 ROLLUP과 CUBE 로 인해 전체합계가 출력되는 위치만 바뀜
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL
GROUP BY ROLLUP(DEPT_CODE);

SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL
GROUP BY CUBE(DEPT_CODE);

-- 부서별로 급여합계를 구하고 전체합계
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL
GROUP BY ROLLUP(DEPT_CODE);

SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL
GROUP BY CUBE(DEPT_CODE);


-- 2개 이상의 컬럼을 GROUP BY 하면 -> ROLLUP과 CUBE는 다른결과를 반환한다. 
-- ROLLUP : 두개의 컬럼 중 왼쪽에 선언된 컬럼을 기준으로 합계 총계를 구함
-- CUBE : 두개의 컬럼 모두를 기준으로 그룹함수를 계산하고 합계 총계를 구함
SELECT DEPT_CODE, JOB_CODE, COUNT(*)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL 
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE) -- DEPT_CODE 컬럼이 기준이 된다. 
ORDER BY 1, 2;
-- 가장 마지막의 값은 총계

SELECT DEPT_CODE, JOB_CODE, COUNT(*)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL 
GROUP BY ROLLUP(JOB_CODE, DEPT_CODE) 
ORDER BY 2, 1;

SELECT DEPT_CODE, JOB_CODE, COUNT(*)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL 
-- GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
-- GROUP BY ROLLUP(JOB_CODE, DEPT_CODE)
-- 아래 큐브구문은 위 두줄의 코드를 합친것과 같음 
GROUP BY CUBE(DEPT_CODE, JOB_CODE) 
ORDER BY 1, 2;

-- 싸그리 다 통계내고싶다 -> CUBE (첫번째 매개변수를 기준으로) 

-- GROUPING
-- GROUP BY에 의해 산출된 ROW인 경우에는 0을 반환
-- ROLLUP / CUBE를 이용해서 산출된 ROW는 1을 반환

SELECT GROUPING(DEPT_CODE), COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE;


SELECT GROUPING(DEPT_CODE), COUNT(*)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL
GROUP BY ROLLUP(DEPT_CODE);

SELECT DEPT_CODE, JOB_CODE, GROUPING(DEPT_CODE), JOB_CODE, GROUPING(JOB_CODE), COUNT(*)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE);

SELECT DEPT_CODE, GROUPING(DEPT_CODE), JOB_CODE, GROUPING(JOB_CODE), COUNT(*)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1, 2;

SELECT CASE
            WHEN GROUPING(DEPT_CODE) = 0 AND GROUPING(JOB_CODE) = 1 THEN '부서별 합계'
            WHEN GROUPING(DEPT_CODE) = 1 AND GROUPING(JOB_CODE) = 0 THEN '직책별 합계'
            WHEN GROUPING(DEPT_CODE) = 1 AND GROUPING(JOB_CODE) = 1 THEN '총합계'
            ELSE '그룹합계'
        END AS 구분, DEPT_CODE, JOB_CODE, 
        SUM(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1;


-- 함수 끝





---------------------- 집합연산자 ------------------------------------------

-- 집합연산자 : 여러개의 SELECT문을 합치거나 중복값을 제거하거나 ..등등 이런 연산을 하는 것

-- SELECT하면  RESULTSET 나옴
-- 집합연산자는 여러개의 RESULTSET을 합치는것 
-- 집합연산자의 성립 조건 : 첫번째 SELECT문의 컬럼의 개수와 컬럼의 타입이 나중의 SELECT문의 것과 동일해야한다. 

-- UNION (합집합) / UNION ALL / INTERSECT / MINUS

-- UNION : 중복값은 한개만 포함해서 여러개의 RESULTSET을 합치는것 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3000000;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, NULL
FROM EMPLOYEE
WHERE SALARY >= 3000000;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, 0
FROM EMPLOYEE
WHERE SALARY >= 3000000;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, NULL
FROM DEPARTMENT;

-- 테이블에 정의된 컬럼을 확인하는 명령어
DESC DEPARTMENT;

-- 3개의 테이블 합침
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, NULL
FROM DEPARTMENT
UNION
SELECT JOB_CODE, JOB_NAME, NULL, 0
FROM JOB;

-- UNION은 중복값을 한개만 표현
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- UNION ALL은 중복값을 있는대로 다 표현
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION ALL
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION ALL
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE = 'J6';


-- INTERSECT ( 교집합 ) :  중복되는 값
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
INTERSECT
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION ALL
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE = 'J6'
INTERSECT 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE MANAGER_ID IS NOT NULL;


-- MINUS ( 빼기 ) : 먼저 나온 테이블에서 중복값을 뺀 나머지 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
MINUS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- GROUPING SETS
SELECT DEPT_CODE, JOB_CODE, MANAGER_ID, FLOOR(AVG(SALARY))
FROM EMPLOYEE
GROUP BY GROUPING SETS(DEPT_CODE, JOB_CODE, MANAGER_ID), 
                      (DEPT_CODE, MANAGER_ID),
                      (JOB_CODE, MANAGER_ID);
                      
-- 위 코드는 아래 코드와 동일
SELECT DEPT_CODE, JOB_CODE, MANAGER_ID, FLOOR(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE, MANAGER_ID;
SELECT DEPT_CODE, JOB_CODE, MANAGER_ID, FLOOR(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE, MANAGER_ID;
SELECT DEPT_CODE, JOB_CODE, MANAGER_ID, FLOOR(AVG(SALARY))
FROM EMPLOYEE
GROUP BY JOB_CODE, MANAGER_ID;

---------------------------------- 집합연산자 끝 -------------------------------

------------------------------- JOIN ---------------------------------------

-- ANSI 표준 구문으로 작성하도록 하자. 명시적으로 JOIN이라고 적기 때문에 가독성도 좋아

-- 기본적인 JOIN
-- ORACLE JOIN
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;

-- ANSI JOIN
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
-- 사원 수는 총 24명인데 22명밖에 안나온다.
-- DEPT_CODE가 NULL인 사원이 사라졌다.

SELECT COUNT(*)
FROM EMPLOYEE;

-- JOIN 은 크게 두가지로 나뉜다

-- 1. EQU JOIN : 테이블을 연결할 때 동등비교로 연결하는 것 ( 일치하는지 아닌지 판단 )

-- INNER JOIN : 기준이 되는 컬럼에 NULL값이 있는 ROW는 생략하고 연결한다. 

SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE DEPT_TITLE = '총무부';

-- 이렇게는 안돼
SELECT *, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE DEPT_TITLE = '총무부';

-- 이렇게는 가능
-- 테이블명에 별칭을 부여할 수 있다
SELECT E.*, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE E JOIN DEPARTMENT D ON DEPT_CODE = DEPT_ID
WHERE DEPT_TITLE = '총무부';

-- EMPLOYEE 테이블과 JOB테이블을 JOIN
SELECT *
FROM EMPLOYEE E JOIN JOB J ON E.JOB_CODE = J.`1 JOB_CODE;
-- 오라클에서 테이블이나 유저를 객체화해놓았기 때문에 .사용해서 객체에 접근 가능
-- JOB_CODE 가 두번 나옴 

-- 두 테이블의 컬럼명이 일치하면 ON 대신 USING 예약어를 사용
SELECT *
FROM EMPLOYEE JOIN JOB USING(JOB_CODE);
-- JOB_CODE 가 한번 나옴



-- OUTER JOIN : 기준이 되는 테이블을 모두 출력하고, 매칭되는 값이 없으면 컬럼에 NULL을 출력함

--  LEFT OUTER JOIN : 왼쪽 테이블 기준
--  RIGHT OUTER JOIN : 오른쪽 테이블 기준

SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE LEFT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

SELECT *
FROM EMPLOYEE LEFT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE RIGHT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

-- 오라클 전용 문법 : (+) 기호
-- LEFT
SELECT *
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+);

-- CROSS JOIN : 카티션 곱 : 각 ROW 전체를 연결
SELECT *
FROM EMPLOYEE;

SELECT *
FROM DEPARTMENT;

SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE CROSS JOIN DEPARTMENT
ORDER BY 1;

-- SELF JOIN : 자기 자신 테이블을 연결 ( 가상으로 분리해야한다)
-- 각 사원의 이름과 매니저 이름을 조회하세요.
SELECT E.EMP_NAME, M.EMP_NAME
FROM EMPLOYEE E JOIN EMPLOYEE M ON E.MANAGER_ID = M.EMP_ID;

SELECT E.EMP_NAME, E.MANAGER_ID, M.EMP_NAME, M.EMP_ID
FROM EMPLOYEE E JOIN EMPLOYEE M ON E.MANAGER_ID = M.EMP_ID;
-- E : 사원 , M : 매니저 

-- 매니저가 없는 사원
-- LEFT OUTER JOIN 작성시 OUTER는 생략 가능
SELECT E.EMP_NAME, NVL(M.EMP_NAME, '없음')
FROM EMPLOYEE E LEFT OUTER JOIN EMPLOYEE M ON E.MANAGER_ID = M.EMP_ID;


-- 다중 JOIN : 2개 이상의 테이블을 연결하는 것



-- 2. NON_EQU JOIN : 테이블을 연결할 때 대소비교, 범위, NULL로 연결하는 것 - 잘 안쓴다

