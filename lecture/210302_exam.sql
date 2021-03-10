
SELECT EMP_NAME AS 사원명, HIRE_DATE AS 입사일, EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) AS "함수식 근무년수"
FROM EMPLOYEE;

-- 모범 답안
SELECT EMP_NAME 이름, HIRE_DATE 입사일,FLOOR(MONTHS_BETWEEN(SYSDATE, HIRE_DATE) / 12) 근무년수
FROM EMPLOYEE;


SELECT HIRE_DATE
FROM EMPLOYEE;

-- 직원 정보가 저장된 EMP 테이블에서 각 부서(DEPT)별 급여(SALARY)의 합계들을 구하여, 부서 급여합이 9백만을 초과하는 부서와 급여합계를 조회하는 SELECT 문을 작성하시오. (25점)
-- 조회한 컬럼명과 함수식에는 별칭 적용한다. (DEPT 부서명, 함수식 급여합)

SELECT DEPT_CODE AS 부서명, SUM(SALARY) AS "함수식 급여합"
FROM EMPLOYEE 
GROUP BY DEPT_CODE
HAVING SUM(SALARY) > 9000000;

--직원의 급여를 인상하고자 한다
--직급코드가 J7인 직원은 급여의 8%를 인상하고,
--직급코드가 J6인 직원은 급여의 7%를 인상하고,
--직급코드가 J5인 직원은 급여의 5%를 인상한다.
--그 외 직급의 직원은 3%만 인상한다.
--직원 테이블(EMP)에서 직원명(EMPNAME), 직급코드(JOBCODE), 급여(SALARY), 인상급여(위 조건)을
--조회하세요(단, DECODE를 이용해서 출력하시오.

SELECT EMP_NAME AS 직원명, JOB_CODE AS 직급코드, SALARY AS 급여, DECODE(JOB_CODE, 'J7', SALARY*0.08+SALARY, 
                                                                    'J6', SALARY*0.07+SALARY,
                                                                      'J5', SALARY*0.05+SALARY,
                                                                         SALARY*0.03+SALARY) AS 인상급여
FROM EMPLOYEE;

-- 급여*0.08+ 급여 

-- 모범 답안
SELECT EMP_NAME, JOB_CODE, SALARY, DECODE(JOB_CODE, 'J7', SALARY * 1.08,
                                                    'J6', SALARY * 1.07,
                                                    'J5', SALARY * 1.05,
                                                        SALARY * 1.03) 인상급여
FROM EMPLOYEE;


--1. 직원테이블(EMP)이 존재한다.
--직원 테이블에서 사원명,직급코드, 보너스를 받는 사원 수를 조회하여 직급코드 순으로 오름차순 정렬하는 구문을 작성하였다.
--이 때 발생하는 문제점을 [원인](10점)에 기술하고, 이를 해결하기 위한 모든 방법과 구문을 [조치내용](30점)에 기술하시오.
SELECT EMP_NAME, JOB_CODE, COUNT(*) AS 사원수
FROM EMPLOYEE
WHERE BONUS IS NOT NULL
GROUP BY EMP_NAME, JOB_CODE
ORDER BY JOB_CODE;



--2.직원 테이블(EMP)에서 부서 코드별 그룹을 지정하여 부서코드, 그룹별 급여의 합계, 그룹별 급여의 평균(정수처리), 인원수를 조회하고 부서코드순으로 나열되어있는 코드 아래와 같이 제시되어있다. 
--아래의 SQL구문을 평균 월급이 2800000초과하는 부서를 조회하도록 수정하려고한다.
--수정해야하는 조건을[원인](30점)에 기술하고, 제시된 코드에 추가하여 [조치내용](30점)에 작성하시오.(60점)
SELECT DEPT_CODE, SUM(SALARY) 합계, FLOOR(AVG(SALARY)) 평균, COUNT(*) 인원수
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE ASC;

-- 수정 후
SELECT DEPT_CODE AS 부서명, FLOOR(AVG(SALARY)) "부서별 급여 평균", COUNT(*) 인원수
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING AVG(SALARY) > 2800000
ORDER BY DEPT_CODE ASC;

