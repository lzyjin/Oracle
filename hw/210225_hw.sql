
-- 서브쿼리 문제

--1. 윤은해와 급여가 같은 사원들을 검색해서, 사원번호,사원이름, 급여를 출력하라.
SELECT EMP_NO, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY = (SELECT SALARY FROM EMPLOYEE WHERE EMP_NAME = '윤은해') AND EMP_NAME != '윤은해';

--2. employee 테이블에서 기본급여가 제일 많은 사람과 제일 적은 사람의 정보를 
-- 사번, 사원명, 기본급여를 나타내세요.
SELECT EMP_NO, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY = (SELECT MAX(SALARY) FROM EMPLOYEE) OR SALARY = (SELECT MIN(SALARY) FROM EMPLOYEE);

--3. D1, D2부서에 근무하는 사원들 중에서
--기본급여가 D5 부서 직원들의 '평균월급' 보다 많은 사람들만 
--부서번호, 사원번호, 사원명, 월급을 나타내세요.
SELECT DEPT_CODE AS 부서번호, EMP_NO AS 사원번호, EMP_NAME AS 사원명, SALARY AS 월급
FROM EMPLOYEE 
    LEFT JOIN DEPARTMENT ON DEPT_ID = DEPT_CODE
WHERE DEPT_CODE IN ('D1', 'D2') AND SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE WHERE DEPT_CODE = 'D5'); 


-- 차태연, 전지연 사원의 급여등급(emplyee테이블의 sal_level컬럼)과 같은 사원의 직급명, 사원명을 출력.
SELECT JOB_NAME AS 직급명, EMP_NAME AS 사원명, SAL_LEVEL AS 급여등급
FROM EMPLOYEE   
    JOIN JOB USING(JOB_CODE)
-- WHERE SAL_LEVEL = (SELECT SAL_LEVEL FROM EMPLOYEE WHERE EMP_NAME = '차태연' OR EMP_NAME = '전지연');
-- 다중행 서브쿼리는 이렇게 
WHERE SAL_LEVEL IN (SELECT SAL_LEVEL FROM EMPLOYEE WHERE EMP_NAME IN ('차태연', '전지연'));
    
SELECT *
FROM DEPARTMENT;

SELECT *
FROM JOB;

SELECT *
FROM EMPLOYEE;



--1.직급이 대표, 부사장이 아닌 모든 사원을 부서별로 출력. 

SELECT *
FROM EMPLOYEE 
    JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME NOT IN('대표', '부사장')
ORDER BY DEPT_CODE ASC;

--2.Asia1지역에 근무하는 사원 정보출력, 부서코드, 사원명.(메인쿼리 조인금지)
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE IN (SELECT DEPT_ID FROM DEPARTMENT 
                                        JOIN LOCATION ON LOCATION_ID = LOCAL_CODE WHERE LOCAL_NAME = 'ASIA1');

SELECT *
FROM LOCATION;

SELECT *
FROM EMPLOYEE;

SELECT *
FROM DEPARTMENT;




--1. 2000년1월1일 이전 입사자중에 2000년 1월1일 이후 입사자보다 급여를 (가장 높게 받는 사원보다) 
--적게 받는 사원의 사원명과 월급여를 출력하세요.
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE TO_CHAR(HIRE_DATE) SALARY < (SELECT SALARY 


--2. 어떤 'J4'직급의 사원보다 많은 급여를 받는 직급이 J5, J6, J7인 사원 출력.

--3. D1 부서의 사원(전체)보다 입사가 늦은 사원들의 정보를 검색하고, 이름, 부서번호, 입사일을 출력하라.

-- 4.  '인사관리부'의 사원전체보다 입사가 늦은 사원들의 정보를 검색하고, 이름, 부서명, 입사일로 출력.


----기술지원부이면서 급여가 2000000인 사원이 있다고 한다.
--해당사원의 이름, 부서코드, 급여를 출력하기
--형식을 부여함.

--3. 직급이 J1, J2, J3이 아닌 사원중에서 자신의 부서별 평균급여보다 많은 급여를 받는 사원출력.
-- 부서코드, 사원명, 급여, 부서별 급여평균

-- 차태연, 전지연 사원의 급여등급(emplyee테이블의 sal_level컬럼)과 같은 사원의 직급명, 사원명을 출력.