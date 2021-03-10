
--0222

-- TO_NUMBER : 문자형 데이터를 숫자형데이터로 변환 ( 산술연산할 때 사용)
-- TO_NUMBER(문자 또는 컬럼, 형식)
-- 에러
SELECT '1,000,000' + '2,000,000' 
FROM DUAL;

SELECT TO_NUMBER('1,000,000', '999,999,999') + TO_NUMBER('2,000,000', '999,999,999')
FROM DUAL;
 
-- 에러
-- 문자열이어도 숫자형태의 데이터가 아니니까 숫자로 못바꾸지
SELECT TO_NUMBER('123A')
FROM DUAL; 


-- NVL() : NULL값을 특정값(문자나 숫자)로 대체시켜주는 함수
-- NVL(컬럼, 대체값): 컬럼의 행을 하나씩 읽으면서 NULL을 대체값으로 대체한다.

-- 보너스가 NULL인 사람은 계산자체가 안되니까 계산을 정상적으로 하기 위해서 NULL을 다른값으로 바꿀 필요가 있다. 
SELECT EMP_NAME, SALARY, (SALARY+(SALARY*BONUS))*12
FROM EMPLOYEE;

-- 사용 방법
SELECT EMP_NAME, SALARY, BONUS, NVL(BONUS, 0)
FROM EMPLOYEE;

SELECT EMP_NAME, SALARY, (SALARY+(SALARY*NVL(BONUS, 0)))*12 AS 보너스포함연봉
FROM EMPLOYEE;

-- DEPT_CODE가 NULL인 사원은 '인턴'으로 출력하기
SELECT EMP_NAME, NVL(DEPT_CODE, '인턴')
FROM EMPLOYEE;

-- 실행순서 : FROM -> WHERE -> SELECT 
-- 그래서 제대로 NULL은 '인턴'으로 바뀜
SELECT EMP_NAME, NVL(DEPT_CODE, '인턴')
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL;

--NVL2() : NULL이면, NULL이 아니면 두가지를 다 대체하는 함수
--NVL2(컬럼, NULL이 아닐때 대체값, NULL일때 대체값)
SELECT EMP_NAME, BONUS, NVL2(BONUS, '있다', '없다')
FROM EMPLOYEE;


-- GREATEST/ LEAST : 최대 / 최소 구하기
-- 문자데이터도 가능. 사전에서 순서가 먼저인것이 최대, 나중인것이 최소.
SELECT GREATEST(1, 2, 3, 4, 5) 
FROM DUAL;

SELECT GREATEST('가', '나', '다')
FROM DUAL;

SELECT GREATEST('B', 'A', 'C')
FROM DUAL;

-- 여러개도 가능
SELECT GREATEST(1, 2, 3, 4, 5), GREATEST('가', '나', '다')
FROM DUAL;

-- 이렇게는 안되네 
-- SELECT GREATEST(SELECT SALARY FROM EMPLOYEE)
-- FROM EMPLOYEE;


-- DECODE() : 선택함수 ( 자바의 switch문과 비슷하다)
-- DECODE(표현식(값), 조건, 결과, 조건1, 결과, 조건2, 결과 .... )

-- EMPLOYEE테이블에서 성별을 추가
-- SUBSTR(EMP_NO, 8, 1)의 결과가 문자이므로 조건도 문자로 '1' 이렇게 적어야한다.
SELECT EMP_NAME, EMP_NO, DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여', '3', '남', '4', '여') AS 성별
FROM EMPLOYEE;

-- 조건없이 결과만 넣으면 디폴트로 되어 나머지를 다 결과로 바꿈
SELECT EMP_NAME, JOB_CODE, DECODE(JOB_CODE, 'J1', '대표', 'J2', '부사장', '기타') AS 직책
FROM EMPLOYEE;




-- CASE문 : DECODE와 활용이 비슷
-- CASE 
--      WHEN  조건1 THEN 결과1
--      WHEN  조건2 THEN 결과2
--      WHEN  조건3 THEN 결과3
-- END

SELECT EMP_NAME, EMP_NO, 
    CASE
        WHEN SUBSTR(EMP_NO, 8, 1) = '1' THEN '남'
        WHEN SUBSTR(EMP_NO, 8, 1) = '2' THEN '여'
    END AS 성별
FROM EMPLOYEE;

SELECT EMP_NAME, EMP_NO, 
    CASE
        WHEN SUBSTR(EMP_NO, 8, 1) = '1' THEN '남'
        ELSE '여'
    END AS 성별
FROM EMPLOYEE;

-- 조건을 이렇게도 작성 가능
SELECT EMP_NAME, EMP_NO,
    CASE SUBSTR(EMP_NO, 8, 1)
        WHEN '1' THEN '남'
        WHEN '3' THEN '남'
        ELSE '여'
    END AS 성별
FROM EMPLOYEE;

-- CASE문을 여러개 쓸때 하나의 CASE문이 끝날때 ,(쉼표)꼭 써야한다!! 까먹지마
SELECT EMP_NAME, EMP_NO, 
    CASE
        WHEN SUBSTR(EMP_NO, 8, 1) = '1' THEN '남'
        ELSE '여'
    END AS 성별,
    CASE
        WHEN SALARY >= 4000000 THEN '고액월급자'
        WHEN SALARY >= 3000000 THEN '중간월급자'
        ELSE '월급자'
    END AS 월급
FROM EMPLOYEE;


-- 사원테이블에서 현재나이를 구해보세요
SELECT EMP_NAME, EMP_NO, SUBSTR(EXTRACT(YEAR FROM SYSDATE), 1, 2)- SUBSTR(EMP_NO,1, 2) AS 나이
FROM EMPLOYEE;

SELECT EMP_NAME, EMP_NO, SYSDATE- TO_DATE(SUBSTR(EMP_NO,1, 6), 'YYMMDD') AS 나이
FROM EMPLOYEE;


-- 선생님 풀이 :
SELECT EMP_ID, EMP_NAME, EMP_NO, EXTRACT(YEAR FROM SYSDATE)- EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1, 2), 'YY')) AS 나이YY
FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, EMP_NO, 
       EXTRACT(YEAR FROM SYSDATE)- EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1, 2), 'YY')) AS 나이YY, 
       EXTRACT(YEAR FROM SYSDATE)- EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1, 2), 'RR')) AS 나이RR
FROM EMPLOYEE;


-- 년도 표현하는 방법 RR과 YY에는 큰 차이가 있다
insert into KH.EMPLOYEE
values ('250','고두밋','470808-2123341','go_dm@kh.or.kr',null,'D2','J2','S5',4480000,null,null,to_date('94/01/20','RR/MM/DD'),null,'N');
commit;


-- YY는 무조건 현재세기가 기준으로 지금년도의 앞2자리를 따른다. 2자리일경우) 만약 년도가 62이면 2062년이 된다. 

-- RR은 입력값과 현재년도에 따라서 처리가 달라진다. 
-- 현재년도가 21이니까 00~49범위이고, 입력년도 62가 50~99범위에 있으니까 현재세기(2062)가 아닌 전세기(한세기 앞서서) 1962가 된다.

-- 따라서 날짜를 연산하거나 빼올때 무작정 빼오면 안된다
-- 1900년도인지 2000년도인지 구분하는 조건을 세울 필요가 있다
SELECT EMP_ID, EMP_NAME, EMP_NO, 
        EXTRACT(YEAR FROM SYSDATE)- EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1, 2), 'YY')) AS 나이YY, 
        EXTRACT(YEAR FROM SYSDATE)- EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1, 2), 'RR')) AS 나이RR,
        
        -- TO_NUMBER(EXTRACT(YEAR FROM SYSDATE)) : 현재의 년도 출력 (4자리)
        -- 아래 코드는 현재의 4자리 연도 - ( 사원의 출생년도 뒤2자리 + 사원이 1990년대생이면 1990 | 사원이 2000년대 생이면 2000) 
        -- -> 현재 4자리 연도 - 출생연도 4자리 -> 나이 (사실은 +1해야함)
       TO_NUMBER(EXTRACT(YEAR FROM SYSDATE))
       - (TO_NUMBER(SUBSTR(EMP_NO, 1, 2)) + 
       CASE 
            WHEN SUBSTR(EMP_NO, 8, 1) IN ('1', '2') THEN 1900 
            ELSE 2000
        END)+1 AS 나이
FROM EMPLOYEE;


