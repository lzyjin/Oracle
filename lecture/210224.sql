
-- 0224

-- 다중 JOIN : 2개 이상의 테이블을 연결하는 것

-- 사원의 부서명, 직책명을 조회하는 SQL문
-- 사원이름(EMPLOYEE), 부서명(DEPARTMENT), 직책명(JOB)
SELECT EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE 
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    JOIN JOB USING (JOB_CODE);
    
-- 사원명, 부서명 근무하고 있는 지역(LOCAL_NAME)을 출력
SELECT EMP_NAME, DEPT_CODE, LOCAL_NAME -- SELECT문에 *을 쓰면 조인한 모든 칼럼을 확인할 수 있음
FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    JOIN LOCATION ON LOCATION_ID = LOCAL_CODE;

-- 직책명도 확인하고싶으면
SELECT EMP_NAME, DEPT_CODE, LOCAL_NAME, JOB_NAME
FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
    JOIN JOB USING(JOB_CODE);

-- 순서 : FROM절부터 아래로 순서대로 작용함. 테이블이 옆으로 순서대로 붙어서 , 그 합쳐진 테이블에 또 새로운 테이블이 붙는 식
SELECT EMP_NAME, DEPT_CODE, LOCAL_NAME, JOB_NAME
FROM EMPLOYEE
    JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    JOIN JOB USING(JOB_CODE);
-- 이렇게 순서를 바꾸면 안맞아서 에러 ( EMPLOYEE테이블에 LOCATION_ID가 없으니까 조인 불가)

-- 위 조인들은 INNER JOIN

-- OUTER조인과 INNER조인을 같이 사용할 수 있다.
-- 부서가 없는 사원들은 null인데 inner join만으로는 모든 사원 (24)명을 출력할 수 없으므로 , outter join으로 해준다.
SELECT EMP_NAME, NVL(DEPT_TITLE, '인턴'), LOCATION_ID, NVL(LOCAL_NAME, '대기발령'), JOB_NAME
FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    LEFT JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
    JOIN JOB USING(JOB_CODE);


-- 유럽에서 근무하는 사람 구하려면
SELECT EMP_NAME, NVL(DEPT_TITLE, '인턴'), LOCATION_ID, NVL(LOCAL_NAME, '대기발령'), JOB_NAME
FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    LEFT JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
    JOIN JOB USING(JOB_CODE)
WHERE LOCAL_NAME = 'EU';

-- JOIN문을 FROM 절이 커진것 뿐, where order by group by having, ...  다 쓸 수 있음


SELECT EMP_NAME, NVL(DEPT_TITLE, '인턴'), LOCATION_ID, NVL(LOCAL_NAME, '대기발령'), JOB_NAME, SALARY
FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    LEFT JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
    JOIN JOB USING(JOB_CODE)
WHERE DEPT_TITLE LIKE '%해외%' AND SALARY > 3000000
ORDER BY 5;


-- 2. NON_EQU JOIN : 테이블을 연결할 때 대소비교, 범위, NULL로 연결하는 것 - 잘 안쓴다

SELECT EMP_NAME, SALARY, SAL_GRADE.SAL_LEVEL
FROM EMPLOYEE JOIN SAL_GRADE ON SALARY BETWEEN MIN_SAL AND MAX_SAL;

SELECT * FROM SAL_GRADE;


------------------------------ 서브 쿼리 -----------------------------------

-- 서브쿼리
-- 하나의 SQL(메인쿼리) 안에 포함되어 또 다른 SQL문(서브쿼리)
-- 서브쿼리는 반드시 소괄호() 로 묶어줘야한다
-- WHERE절에 사용할 때는 오른쪽에 위치한다.

-- 전지연 사원의 관리자 이름을 구해라
SELECT MANAGER_ID
FROM EMPLOYEE
WHERE EMP_NAME = '전지연';

SELECT EMP_NAME 
FROM EMPLOYEE
WHERE EMP_ID = 214;

-- 셀프조인으로 구해보기
SELECT M.EMP_NAME
FROM EMPLOYEE E JOIN EMPLOYEE M ON E.MANAGER_ID = M.EMP_ID
WHERE E.EMP_NAME = '전지연';

-- 서브쿼리로 구해보기
SELECT EMP_NAME
FROM EMPLOYEE
WHERE EMP_ID = (SELECT MANAGER_ID FROM EMPLOYEE WHERE EMP_NAME = '전지연');

-- 사원의 평균 급여보다 많이 받는 사원은?
-- 사원명, 부서명, 직책명, 급
SELECT EMP_NAME, DEPT_TITLE, JOB_NAME, SALARY
FROM EMPLOYEE 
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    JOIN JOB USING(JOB_CODE)
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE);





-- 단일행 서브쿼리 : 서브쿼리의 결과가 한개의 열, 한개의 행을 의미함
-- 윤은해 사원과 동일한 급여를 받고있는 사원을 구하세요
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY = ( SELECT SALARY FROM EMPLOYEE WHERE EMP_NAME = '윤은해');

-- 사원의 최대 급여를 받고있는 사원과 최소급여를 받고있는 사원의 이름과 급여를 구하라
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY = (SELECT MAX(SALARY) FROM EMPLOYEE ) 
    OR SALARY = (SELECT MIN(SALARY) FROM EMPLOYEE );






-- 다중행 서브쿼리 : 한개의 컬럼에 행이 다수가 나오는 SELECT문
-- 행이 다수이기 때문에 = 등호로 비교가 불가능, 동등비교할 때는 IN 또는 NOT IN(OR 개념)써야한다.
-- ANY, ALL, EXIST(상관서브쿼리)

-- 송종기, 박나라와 같은 부서에서 근무하는 사원의 이름과 부서를 조회
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
-- WHERE DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME IN('송종기', '박나라')); -- 에러 
WHERE DEPT_CODE IN (SELECT DEPT_CODE 
                    FROM EMPLOYEE 
                    WHERE EMP_NAME IN('송종기', '박나라'));
-- 위 코드는 아래코드와 같음
-- WHERE DEPT_CODE IN('D9', 'D6')

-- 송종기, 박나라와 다른부서에서 근무하는 사원의 이름과 부서를 조회
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE NOT IN (SELECT DEPT_CODE 
                        FROM EMPLOYEE 
                        WHERE EMP_NAME IN('송종기', '박나라'));
-- 위 코드는 아래 코드와 같음
-- NOT IN('D9', 'D6')

-- 직급이 대표, 부사장이 아닌 모든 사원 출력하기
SELECT *
FROM EMPLOYEE
WHERE JOB_CODE NOT IN (SELECT JOB_CODE 
                       FROM EMPLOYEE 
                       WHERE JOB_CODE IN ('J1', 'J2'));

-- ASIA1에서 근무하는 사원 조회
SELECT *
FROM EMPLOYEE 
WHERE DEPT_CODE IN (SELECT DEPT_ID 
                    FROM DEPARTMENT 
                        JOIN LOCATION ON LOCATION_ID = LOCAL_CODE  
                    WHERE LOCAL_NAME = 'ASIA1');

SELECT *
FROM LOCATION;

SELECT *
FROM JOB;

SELECT *
FROM DEPARTMENT;

SELECT *
FROM EMPLOYEE;


-- ANY /  SOME
-- ANY : 대소비교, 동등비교 
-- X >(=) ANY(값1, 값2) : ANY에 있는 어떤값보다 X가 크기만하면 TRUE, 최소값보다 크면 TRUE ( OR 개념 )
-- X <(=) ANY(값1, 값2) : ANY에 있는 어떤값보다 X가 작기만하면 TRUE, 최대값보다 작으면 TRUE ( OR 개념 )

-- 월급이 200만원보다 크기만 하면 되는 결과가 나옴
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY > ANY(2000000, 5000000);

-- 2명 빠졌다.
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY > ANY(SELECT SALARY FROM EMPLOYEE WHERE DEPT_CODE IN ('D5', 'D6'));

-- 직책이 J3인 사원들 중 최소급여보다 많이 받는 사원을 조회
SELECT EMP_NAME, SALARY, JOB_CODE
FROM EMPLOYEE
WHERE SALARY > ANY(SELECT SALARY FROM EMPLOYEE WHERE JOB_CODE = 'J3');

--월급이 390보다 작은 사람 다 
SELECT EMP_NAME, SALARY, JOB_CODE
FROM EMPLOYEE
WHERE SALARY < ANY(SELECT SALARY FROM EMPLOYEE WHERE JOB_CODE = 'J3');


-- ALL : 모든값보다 크다, 작다 ( AND 개념 )
-- x > ALL(값1, 값2 ...) : x가 ALL의 모든값보다 큰 x -> 최대값보다 크면 true

-- 월급이 500보다 큰 사원
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY > ALL(2000000, 5000000);

-- 부서가 D2인 사원들 중 사원의 최대급여를 받는 사원보다 더 받는 사원 조회
SELECT *
FROM EMPLOYEE
-- 둘다 가능 
-- WHERE SALARY > ALL(SELECT SALARY FROM EMPLOYEE WHERE DEPT_CODE = 'D2');
WHERE SALARY > (SELECT MAX(SALARY) FROM EMPLOYEE WHERE DEPT_CODE = 'D2');

-- 2000년 1월 1일 이전 입사자중에, 2000년 1월 1일 이후 입사자보다 급여를 가장 높게받는 사원보다 적게받는 사원들의 사원명과 월급여 조회 
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
--WHERE SALARY > ALL(SELECT SALARY FROM EMPLOYEE WHERE HIRE_DATE > '2000/01/01');
WHERE HIRE_DATE < '00/01/01' 
    AND SALARY > ALL(SELECT SALARY FROM EMPLOYEE WHERE HIRE_DATE > '00/01/01');

-- 어떤 'J4'직급의 사원보다 많은 급여를 받는, 직급이 J5, J6, J7인 사원 조회
SELECT *
FROM EMPLOYEE
WHERE SALARY > ANY(SELECT SALARY FROM EMPLOYEE WHERE JOB_CODE = 'J4') 
    AND JOB_CODE IN('J5', 'J6', 'J7');





-- 다중열 서브쿼리 : 행이 하나이면서 컬럼이 여러개인 서브쿼리
-- 퇴직한 여자 사원의 같은부서, 같은 직급에 해당하는 사원 조회
SELECT DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE ENT_YN = 'Y';

SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE WHERE ENT_YN = 'Y')
        AND JOB_CODE = (SELECT JOB_CODE FROM EMPLOYEE WHERE ENT_YN = 'Y');
        
-- 더 효율적으로 쓰자
SELECT *
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) IN (SELECT DEPT_CODE, JOB_CODE FROM EMPLOYEE WHERE ENT_YN = 'Y');

-- IN 은 ROW를 OR로 보니까 위의 다중열쿼리에서의 IN은 OR이 적용되지 않음


-- 기술지원부이면서 급여가 200만원인 사원
-- 사원의 이름, 부서코드 급여

SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID 
WHERE SALARY = 2000000 AND DEPT_TITLE IN (SELECT DEPT_TITLE FROM DEPARTMENT WHERE DEPT_TITLE = '기술지원부');


-- 선생님 풀이
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID 
WHERE (DEPT_TITLE, SALARY) IN (SELECT DEPT_TITLE, SALARY 
                                FROM EMPLOYEE
                                    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
                                WHERE DEPT_TITLE = '기술지원부' AND SALARY = 2000000);






-- 다중행, 다중열 서브쿼리 : 행도 여러개, 열도 여러개
-- 부서별 최소 급여
SELECT DEPT_CODE, MIN(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 부서별 최소급여를 받는 사원의 이름, 부서
-- 선생님 풀이 
SELECT EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE 
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE (DEPT_CODE, SALARY) IN (SELECT DEPT_CODE, MIN(SALARY) 
                                FROM EMPLOYEE 
                                GROUP BY DEPT_CODE);
                                -- DEPT_CODE, MIN(SALARY)는 AND로 묶임 
                                --and로 묶인 행들이 or로 여러개 나오니까 in 사용 
                                -- ( 열은 and로, 행은 or로 묶임)

SELECT *
FROM DEPARTMENT;




----------------------  상관 서브쿼리  ----------------------------
-- 상관 서브쿼리
-- 서브쿼리를 구성할 때 메인쿼리에 있는 값을 가져와 사용을 하게 작성한다
-- 상관서브쿼리는 JAVA의 이중FOR문과 비슷하다. 
-- 메인쿼리의 값이 서브쿼리의 resultset에 영향을 주고, 서브쿼리의 결과가 메인쿼리의 결과에 영향을 준다. 
-- 상관서브쿼리의 결과는 각 행마다 달라질 수 있다. 

-- EXISTS : ROW가 한개라도 있으면 무조건 TRUE, ROW가 없으면 FALSE

-- 24개 
SELECT *
FROM EMPLOYEE
WHERE EXISTS(SELECT 1 FROM EMPLOYEE WHERE DEPT_CODE = 'D5');

-- 0개 
SELECT *
FROM EMPLOYEE
WHERE EXISTS(SELECT 1 FROM EMPLOYEE WHERE DEPT_CODE = 'D20');

-- 부하직원이 있는 사원을 조회 
SELECT EMP_ID, EMP_NAME, MANAGER_ID
FROM EMPLOYEE E
WHERE EXISTS(SELECT 1  FROM EMPLOYEE WHERE MANAGER_ID = E.EMP_ID);

-- 심봉선 사원과 같은 부서인 사원의 부서코드, 사원명 ( 다시...)
SELECT DEPT_CODE, EMP_NAME
FROM EMPLOYEE E
WHERE EXISTS(SELECT EMP_NAME FROM EMPLOYEE WHERE E.DEPT_CODE = DEPT_CODE AND EMP_NAME = '심봉선');


-- 가장 많은 급여를 받는 사원을 EXISTs연산자를 이용해서 구하기
-- 힌트 : NOT EXISTS :  급여를 비교했을 때 월급이 높은사람이 없을 때 그 사람이 최고값임 

--  선생님 풀이 
SELECT *
FROM EMPLOYEE E 
WHERE NOT EXISTS(SELECT SALARY FROM EMPLOYEE WHERE SALARY > E.SALARY);


-- 최소급여를 받는 사원을 상관서브쿼리로 구하면?
SELECT *
FROM EMPLOYEE E
WHERE NOT EXISTS(SELECT SALARY FROM EMPLOYEE WHERE SALARY < E.SALARY);






-- 스칼라 서브쿼리
-- 상관 서브쿼리의 결과가 단일행인 쿼리문
-- 결과가 하나라서 select문의 where 또는 select문의 컬럼이 들어가는 곳에 사용 

-- 모든 사원의 사번, 이름, 관리자 번호, 관리자명을 조회
SELECT E.EMP_ID, E.EMP_NAME, E.MANAGER_ID, M.EMP_NAME
FROM EMPLOYEE E
    JOIN EMPLOYEE M ON E.MANAGER_ID = M.EMP_ID;

-- 스칼라 서브쿼리로 
-- 결과값이 하나의 행으로 나오므로 SELECT문에 사용 가능 
-- EMP_ID는 식별자고 기본키라서 대응되는 값이 하나만 출력되는데.
SELECT EMP_ID, EMP_NAME, MANAGER_ID, (SELECT EMP_NAME FROM EMPLOYEE WHERE EMP_ID = E.MANAGER_ID) AS 관리자명
FROM EMPLOYEE E;

-- 이건 안돼 
-- DEPT_CODE는 중복될 수 있는 컬럼이라서 서브쿼리로 이용시 여러개 결과값이 나오므로 아래코드는 에러가 난다. 
SELECT EMP_ID, EMP_NAME, MANAGER_ID, (SELECT EMP_NAME FROM EMPLOYEE WHERE DEPT_CODE = E.DEPT_CODE) AS 관리자명
FROM EMPLOYEE E;


-- 사원명, 부서코드, 급여, 부서별 평균임금을 조회
SELECT EMP_NAME, DEPT_CODE, SALARY, (SELECT (DEPT_CODE, AVG(SALARY)) 
                                     FROM EMPLOYEE 
                                     GROUP BY DEPT_CODE) 
FROM EMPLOYEE;

-- 이렇게 GROUP BY를 쓰면 부서별 평균이 나오지만 전체 부서에 대한 정보가 다 나옴 -> 여러행의 결과 
SELECT DEPT_CODE, AVG(SALARY) FROM EMPLOYEE GROUP BY DEPT_CODE;

-- 부서별 평균 임금 구하는법
-- 이렇게 작성하면 부서별로 하나의 결과값이 나오니까 스칼라서브쿼리로 사용 가능 
SELECT AVG(SALARY) FROM EMPLOYEE WHERE DEPT_CODE = 'D6';
SELECT AVG(SALARY) FROM EMPLOYEE WHERE DEPT_CODE = 'D9';

-- 선생님 풀이
-- 부서코드가 NULL인 행도 급여가 정상적으로 계산되게 하기 위해서 NVL 사용 
SELECT EMP_NAME, DEPT_CODE, SALARY, TO_CHAR(FLOOR((SELECT AVG(SALARY) FROM EMPLOYEE WHERE NVL(DEPT_CODE, 1) = NVL(E.DEPT_CODE, 1))), 'L999,999,999') AS "부서별 평균"
FROM EMPLOYEE E;



-- 부서별 평균
SELECT DEPT_CODE,AVG(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT AVG(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- 직급이 J1이 아닌 사원중에서 자신의 부서별 평균 급여보다 적은 급여를 받는 사원을 출력
-- 부서코드, 사원명, 급여, 부서별 급여평균
SELECT JOB_CODE, DEPT_CODE, EMP_ID, EMP_NAME, SALARY, FLOOR((SELECT AVG(SALARY) FROM EMPLOYEE WHERE DEPT_CODE = E.DEPT_CODE)) AS "부서별 급여평균"
FROM EMPLOYEE E
WHERE JOB_CODE != 'J1' AND SALARY < (SELECT AVG(SALARY) FROM EMPLOYEE WHERE DEPT_CODE = E.DEPT_CODE)
ORDER BY DEPT_CODE ASC;

-- WHERE절에도 스칼라서브쿼리를 사용할 수 있다.

-- 자신이 속한 직급의 평균 급여보다 많이 받는 사원의 이름, 직책명, 급여를 조회
SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE  
    JOIN JOB USING(JOB_CODE)
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE GROUP BY JOB_CODE);

-- 그룹바이를 하면 하나하나 비교할수 없어서 안된대

-- 선생님 풀이 
SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E
    JOIN JOB USING(JOB_CODE) -- USING을 쓰면 JOB테이블에 별칭을 붙일 수 없어. 
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE E WHERE JOB_CODE = E.JOB_CODE);
-- 서브쿼리의 FROM안에있는 EMPLOYEE에도 같은 별칭을 붙여야해 

-- 아깝다... 좀만 더 생각하면 풀 수 있었는데..


-- 인라인 뷰 : FROM절에 SELECT문이 들어가는 것
-- 물리적인 테이블이 아닌 RESULTSET을 테이블처럼 취급 (그래서 VIEW)
-- IN-LINE VIEW : FROM절에 서브쿼리를 사용한 것 (다중열, 다중행 서브쿼리)
-- STORED VIEW : 영구적으로 저장하고 사용하는 VIEW 

-- 여자사원의 사번, 사원명, 부서코드, 성별을 출력
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') AS 성별
FROM EMPLOYEE
WHERE DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') = '여';

-- 이렇게도 쓸 수 있어
-- 서브쿼리의 RESULTSET을 하나의 테이블로 보고, 그 테이블을 이용 -> 통째로 FROM에 쓸 수 있다.
SELECT *
FROM (SELECT EMP_ID, EMP_NAME, DEPT_CODE, DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') AS 성별
        FROM EMPLOYEE)
WHERE 성별 = '여';

