
-- 함수_JOIN 

--1. 직원명과 이메일 , 이메일 길이를 출력하시오
--		  이름	    이메일		이메일길이
--	ex) 	홍길동 , hong@kh.or.kr   	  13

SELECT EMP_NAME AS 이름, EMAIL AS 이메일, LENGTH(EMAIL) AS 이메일길이
FROM EMPLOYEE
ORDER BY 1 ASC;


--3. 60년대에 태어난 직원명과 년생, 보너스 값을 출력하시오. 그때 보너스 값이 null인 경우에는 0 이라고 출력 되게 만드시오
--	    직원명    년생      보너스
--	ex) 선동일	    1962	    0.3
--	ex) 송은희	    1963  	    0

SELECT EMP_NAME AS 직원명, CONCAT('19',SUBSTR(EMP_NO, 1, 2)) AS 년생, NVL(BONUS, '0') AS 보너스
FROM EMPLOYEE;


--4. '010' 핸드폰 번호를 쓰지 않는 사람의 수를 출력하시오 (뒤에 단위는 명을 붙이시오)
--	   인원
--	ex) 3명
SELECT *
FROM EMPLOYEE;

SELECT COUNT(*)|| '명' AS 인원
FROM EMPLOYEE
WHERE SUBSTR(PHONE, 1, 3) != '010';



--5. 직원명과 입사년월을 출력하시오 
--	단, 아래와 같이 출력되도록 만들어 보시오
--	    직원명		입사년월
--	ex) 전형돈		2012년 12월
--	ex) 전지연		1997년 3월

SELECT EMP_NAME AS 직원명,
        EXTRACT(YEAR FROM HIRE_DATE) || '년 ' || EXTRACT(MONTH FROM HIRE_DATE) || '월' AS 입사년월
FROM EMPLOYEE;


--6. 직원명과 주민번호를 조회하시오
--	단, 주민번호 9번째 자리부터 끝까지는 '*' 문자로 채워서출력 하시오
--	ex) 홍길동 771120-1******

SELECT EMP_NAME, RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*')
FROM EMPLOYEE;


--7. 직원명, 직급코드, 연봉(원) 조회
--  단, 연봉은 ￦57,000,000 으로 표시되게 함
--     연봉은 보너스포인트가 적용된 1년치 급여임
SELECT EMP_NAME AS 직원명, DEPT_CODE AS 직급코드, TO_CHAR((SALARY+(SALARY*BONUS))*12, 'L999,999,999') AS 연봉
FROM EMPLOYEE; 

--8. 부서코드가 D5, D9인 직원들 중에서 2004년도에 입사한 직원중에 조회함.
--   사번 사원명 부서코드 입사일
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D9') AND EXTRACT(YEAR FROM HIRE_DATE) = 2004; 

--9. 직원명, 입사일, 오늘까지의 근무일수 조회 
--	* 주말도 포함 , 소수점 아래는 버림
SELECT EMP_NAME, HIRE_DATE, FLOOR(SYSDATE - HIRE_DATE)
FROM EMPLOYEE;

-- 질문 
--11. 직원들의 입사일로 부터 년도만 가지고, 각 년도별 입사인원수를 구하시오.
--  아래의 년도에 입사한 인원수를 조회하시오. 마지막으로 전체직원수도 구하시오
--  => decode, sum 사용

--	-------------------------------------------------------------------------
--	 1998년   1999년   2000년   2001년   2002년   2003년   2004년  전체직원수
--	-------------------------------------------------------------------------

-- 해당조건을 만족하면 해당row에 값을 준다. null이 아닌 어떤 값이라도 좋다.
-- 설명 : count변수(특정컬럼을 센다)가 하나 있고, 매행마다, null이 아니라면 ++1 해줌.

SELECT SUBSTR(TO_CHAR(HIRE_DATE, 'YYYY/MM/DD'), 1, 4), COUNT(emp_name)
FROM EMPLOYEE
GROUP BY SUBSTR(TO_CHAR(HIRE_DATE, 'YYYY/MM/DD'), 1, 4)
--HAVING TO_NUMBER(SUBSTR(TO_CHAR(HIRE_DATE, 'YYYY/MM/DD'), 1, 4)) = 1998
HAVING TO_NUMBER(SUBSTR(TO_CHAR(HIRE_DATE, 'YYYY/MM/DD'), 1, 4)) IN(1998, 1999, 2000, 2001, 2002, 2003, 2004)
ORDER BY 1 ASC; -- 행으로 나누어 나오니까 이렇게 하면 안돼 ! 

SELECT COUNT(DECODE(SUBSTR(TO_CHAR(HIRE_DATE, 'YYYY/MM/DD'), 1, 4),'1998', '1')) AS "1998년",
        COUNT(DECODE(SUBSTR(TO_CHAR(HIRE_DATE, 'YYYY/MM/DD'), 1, 4),'1999', 1)) AS "1999년",
        COUNT(DECODE(SUBSTR(TO_CHAR(HIRE_DATE, 'YYYY/MM/DD'), 1, 4),'2000', 1)) AS "2000년",
        COUNT(DECODE(SUBSTR(TO_CHAR(HIRE_DATE, 'YYYY/MM/DD'), 1, 4),'2001', 1)) AS "2001년",
        COUNT(DECODE(SUBSTR(TO_CHAR(HIRE_DATE, 'YYYY/MM/DD'), 1, 4),'2002', 1)) AS "2002년",
        COUNT(DECODE(SUBSTR(TO_CHAR(HIRE_DATE, 'YYYY/MM/DD'), 1, 4),'2003', 1)) AS "2003년",
        COUNT(DECODE(SUBSTR(TO_CHAR(HIRE_DATE, 'YYYY/MM/DD'), 1, 4),'2004', 1)) AS "2004년"
FROM EMPLOYEE;



--12. 사원명과, 부서명을 출력하세요.
--   부서코드가 D5이면 총무부, D6이면 기획부, D9이면 영업부로 처리하시오.(case 사용)
--   단, 부서코드가 D5, D6, D9 인 직원의 정보만 조회하고, 부서코드 기준으로 오름차순 정렬함.
SELECT EMP_NAME, DEPT_TITLE,DEPT_CODE,
    CASE
        WHEN DEPT_CODE = 'D5' THEN '총무부'
        WHEN DEPT_CODE = 'D6' THEN '기획부'
        WHEN DEPT_CODE = 'D9' THEN '영업부'
    END
FROM EMPLOYEE 
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE DEPT_CODE IN ( 'D5', 'D6', 'D9') 
ORDER BY DEPT_CODE ASC;


--EMPLOYEE 테이블에서 직급이 J1을 제외하고, 직급별 사원수 및 평균급여를 출력하세요.
SELECT COUNT(*)
FROM EMPLOYEE
WHERE JOB_CODE != J1 AND ;

--EMPLOYEE테이블에서 직급이 J1을 제외하고,  입사년도별 인원수를 조회해서, 입사년 기준으로 오름차순 정렬하세요.
SELECT COUNT(*)
FROM EMPLOYEE
WHERE DEPT_CODE != 'J1'
GROUP BY SUBSTR(TO_CHAR(HIRE_DATE), 1, 2)
ORDER BY HIRE_DATE ASC;

--[EMPLOYEE] 테이블에서 EMP_NO의 8번째 자리가 1, 3 이면 '남', 2, 4 이면 '여'로 결과를 조회하고,
-- 성별별 급여의 평균(정수처리), 급여의 합계, 인원수를 조회한 뒤 인원수로 내림차순을 정렬 하시오


--부서내 성별 인원수를 구하세요.

--부서별 인원이 3명보다 많은 부서와 인원수를 출력하세요.

--부서별 직급별 인원수가 3명이상인 직급의 부서코드, 직급코드, 인원수를 출력하세요.

--매니져가 관리하는 사원이 2명이상인 매니져아이디와 관리하는 사원수를 출력하세요.

--부서명과 지역명을 출력하세요. DEPARTMENT, LOCATION 테이블 이용.

--지역명과 국가명을 출력하세요. LOCATION, NATION 테이블

--지역명과 국가명을 출력하세요. LOCATION, NATION 테이블을 조인하되 USING을 사용할것.