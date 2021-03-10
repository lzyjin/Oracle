
--0222

-- 직원 정보를 저장한 EMP 테이블에서 사원명(ENAME)과 주민번호(ENO)를 함수를 사용하여 아래의 요구대로 조회되도록 SELECT 구문을 기술하시오. (25점)
--'- 주민번호는 '891224-1******' 의 형식으로 출력되게 하시오
-- 조회결과에 컬럼명은 별칭 처리하시오. => ENAME 사원명, ENO 주민번호

-- 내가 푼 답안 ( 부분점수만 받았다..)
SELECT EMP_NAME AS 사원명, CONCAT(SUBSTR(EMP_NO, 1, 8), '******') AS 주민번호
FROM EMPLOYEE;

-- 정답 
SELECT EMP_NAME 사원명, RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*') 주민번호
FROM EMPLOYEE;

--검색조건
--DEPT_CODE가 D9이거나 D6이고 / SALARY이 300만원 이상이고 /BONUS가 있고 / 남자면서 / 이메일주소가 _ 앞에 3글자 있는
--사원의 EMP_NAME, EMP_NO, DEPT_CODE, SALARY를 조회

--작성된 쿼리구문
SELECT EMP_NAME, EMP_NO, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE='D9' OR DEPT_CODE='D6' AND SALARY > 3000000 AND EMAIL LIKE '____%' AND BONUS IS NULL;
--* 5개의 문제점이 있음

SELECT EMP_NAME, EMP_NO, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE (DEPT_CODE='D9' OR DEPT_CODE='D6') 
        AND SALARY >= 3000000 
        AND EMAIL LIKE '___\_%' ESCAPE '\'
        AND BONUS IS NOT NULL
        AND SUBSTR(EMP_NO, 8, 1) = 1;
        
SELECT * 
FROM EMPLOYEE 
WHERE BONUS =NULL AND MANAGER_ID !=NULL;
-- NULL값에 대한 비교처리가 되지 않았다.

SELECT * 
FROM EMPLOYEE 
WHERE BONUS IS NULL AND MANAGER_ID IS NOT NULL;

