-- 0219
-- 문자열 함수에 대해 알아보자
-- LENGTH : 문자열 또는 (문자타입의)컬럼의 길이를 알려주는 기능
SELECT LENGTH('안녕하세요')
FROM DUAL;

SELECT EMP_NAME, LENGTH(EMP_NAME), EMAIL
FROM EMPLOYEE;

SELECT EMP_NAME, EMAIL, LENGTH(EMAIL)
FROM EMPLOYEE
WHERE LENGTH(EMAIL) >= 16; -- LENGTH는 WHERE절에도 사용 가능

-- LENGTHB : 문자열 또는 (문자타입)컬럼의 길이를 BYTE단위로 출력
-- 영문자는 각각 1바이트, 한글은 3바이트 ! 
SELECT EMP_NAME, LENGTHB(EMP_NAME)
FROM EMPLOYEE;

-- 오라클 EXPRESS 버전에서는 한글을 3byte로 처리 / ENTERPRICE 에서는 2byte로 처리
SELECT LENGTHB('ASB') 
FROM EMPLOYEE;

-- INSTR
-- 찾는 문자열이 지정한 위치부터 지정한 횟수번째에 나타나는 위치 반환( 인덱스 반환 )
-- INSTR(대상 문자열 또는 컬럼, 찾는 문자열 또는 컬럼, 시작위치, 몇번째에서 찾을건지)
-- ORACLE 에서는 인덱스 번호의 시작이 0이 아니라 1이다
-- 시작위치가 양수 : 왼 -> 오 방향, 시작위치 음수 : 오 -> 왼 방향으로 찾음
SELECT INSTR('KH정보교육원', 'KH')
FROM DUAL;

SELECT INSTR('KH정보교육원 KH수강생화이팅', 'KH', 3) -- 결과 : 9 (인덱스번호)
FROM DUAL;

-- 3번인덱스부터 찾아서 2두번째로 나온 값이 있는곳의 인덱스번호가 18
SELECT INSTR('KH정보교육원 KH수강생화이팅 KH강남 RCLASS힘내라', 'KH', 3, 2) -- 18
FROM DUAL;

SELECT INSTR('KH정보교육원 KH수강생화이팅 KH강남 RCLASS힘내라', 'KH', -1, 2) -- 9
FROM DUAL;

-- EMPLOYEE 테이블에서 EMAIL의 @의 위치를 구하세요
SELECT EMAIL, INSTR(EMAIL, '@')
FROM EMPLOYEE;

-- LPAD / RPAD : 할당된 공간에서 빈공간의 왼오른쪽을 특정문자로 채우는 기능
-- LPAD/RPAD(문자열 또는 컬럼, 공간의 크기, 문자) 
-- L : left 왼쪽을 채움
-- R : right 오른쪽을 채움

SELECT LPAD('KIMYJ', 10, '*')
FROM DUAL; --한글은 2바이트씩이라서 조금 알아차리기 힘들다.

SELECT RPAD('KIMYJ', 20, '^')
FROM DUAL;

SELECT EMP_NAME, EMAIL, RPAD(EMAIL, 20, '#')
FROM EMPLOYEE;

-- 채워넣을 문자를 설정하지 않으면 공백을 채운다 (DEFAULT가 공백)
SELECT LPAD('KIMYJ', 10)
FROM DUAL; 

-- LTRIM / RTRIM : 문자열의 왼/오른쪽에 있는 공백이나 지정문자를 제거
-- L/TRIM(대상 문자열이나 컬럼, [문자])
SELECT LTRIM('     YE  JIN     ') -- 왼쪽 공백 제거(문자열 사이에 있는 공백은 제거되지 않음)
FROM DUAL;

SELECT RTRIM('    YEJIN    ') -- 오른쪽 공백 제거
FROM DUAL;

-- SELECT *
-- FROM EMPLOYEE
-- WHERE EMP_NAME = 'YEJIN'; 만약에 위에처럼 저장되어있는데 공백없는 문자열을 검색하면 검색되지 않으므로 trim을 써야한다 (중요!)

SELECT LTRIM('000012312434355400', '0') -- 왼쪽에 있는 0이 제거된다
FROM DUAL;

SELECT LTRIM('000001111010101010101', '0') 
FROM DUAL;

SELECT LTRIM('000001111010101010101', '01') -- 왼쪽에 해당하는 문자 없음 -> 결과 없음 
FROM DUAL;

-- 23414324930487YEJIN에서 YEJIN만 남기세요
SELECT LTRIM('12343456YEJIN', '0123456789')
FROM DUAL;

-- 23414324930487YEJIN4831054927827 에서 YEJIN만 남기세요 (힌트 반환있음)
SELECT RTRIM(LTRIM('234432493487YEJIN4831054927827', '0123456789'), '0123456789')
FROM DUAL;

-- TRIM : 옵션에 따라 문자열 양쪽이나 왼오른쪽에 있는 특정 문자를 제거한다, 단 찾을 특정 문자는 1개만 지정 가능)
-- TRIM(대상 문자열 또는 컬럼) : 공백 제거 
-- TRIM(대상 문자열 또는 컬럼, 제거할 문자)
-- TRIM(제거할 문자 FROM 대상 문자열) : 대상 문자열의 양쪽에서 문자를 제거, 단 제거할 문자는 한자리문자여야한다.
-- TRIM(LEADING 또는 TRAILING 또는 BOTH 제거할 문자 FROM 문자열이나 컬럼)

SELECT TRIM('    YEJIN    ') AS A  -- 양쪽 공백 제거
FROM DUAL;

SELECT TRIM('  A   YEJIN   B   ') -- 문자열 사이에 있는 공백은 제거되지 않는다
FROM DUAL;

-- 문자열 사이에 있는  Z는 제거되지 않는다
SELECT TRIM('Z' FROM 'ZZZZZZYEZJINZZZZZ') -- 'ZZ'이렇게 두자리 이상의 문자를 찾는것은 불가능
FROM DUAL;

SELECT TRIM(LEADING FROM '     YEJIN      ') AS A
FROM DUAL;


SELECT TRIM(TRAILING FROM '     YEJIN      ') AS A
FROM DUAL;

SELECT TRIM(LEADING 'ㅋ' FROM 'ㅋㅋㅋㅋ크크킄ㅋㅋㅋ') AS A
FROM DUAL;

-- SUBSTR : 컬럼이나 문자열에서 지정한 위치부터 지정한 개수만큼 잘라내어 반환
-- SUBSTR( 문자열 또는 컬럼, 시작위치, 길이( 생략가능, 생략시 문자열의 끝까지) )
SELECT SUBSTR('SHOWMETHEMONEY', 5) -- METHEMONEY
FROM DUAL;

SELECT SUBSTR('SHOWMETHEMONEY', 5, 2) -- METHEMONEY
FROM DUAL;

SELECT SUBSTR('SHOWMETHEMONEY', -1, 3) -- Y
FROM DUAL;

SELECT EMP_NAME, SUBSTR(EMP_NO, 1, 6) -- 사원의 생년월일만 출력 가능
FROM EMPLOYEE;

-- 여자사원의 이름과 번호를 조회
SELECT EMP_NAME, EMP_NO 
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = 2;

SELECT SUBSTR(EMAIL, INSTR(EMAIL, '@')  ) -- 산술연산 가능 ( @부터 끝까지 잘라냄)
FROM EMPLOYEE;

SELECT SUBSTR('12345', 3)
FROM DUAL;

-- 영문자 관련
-- 대문자로, 소문자로, 첫글자만 대문자로
-- LOWER / UPPER / INITCAP
SELECT LOWER('Welcome To OracleWorld')
FROM DUAL;

SELECT UPPER('Welcome To OracleWorld')
FROM DUAL;

SELECT INITCAP('welcome to oracleworld') -- 띄어쓰기도 인식해서 각 부분의 첫글자를 대문자로 다 변경
FROM DUAL;

SELECT EMAIL
FROM EMPLOYEE
WHERE EMAIL LIKE '%KH%'; --  실제 데이터들은 대소문자를 구분하므로 이렇게 하면 제대로 된 값을 조회할 수 없다

SELECT EMAIL
FROM EMPLOYEE
WHERE EMAIL LIKE LOWER('%KH%'); -- 제대로 출력된다

-- CONCAT : 문자열의 연결연산 == || 연산자
-- CONCAT(문자열 또는 컬럼, 문자열 또는 컬럼)
SELECT CONCAT('여러분', ' 오라클 재미있나요?')
FROM DUAL;

SELECT '여러분' || ' 오라클 재미있나요?'
FROM DUAL;


SELECT CONCAT(EMP_NAME, '님')
FROM EMPLOYEE;

-- REPLACE : 특정문자를 변경
-- REPLACE( 대상 문자열 혹은 컬럼, 바꿀 대상 문자, 바꿀 새 문구)
SELECT REPLACE('I LOVE MY LIFE', 'LOVE', 'HATE')
FROM DUAL;

SELECT REPLACE(EMAIL, 'kh.or.kr', 'bs.com')
FROM EMPLOYEE;

-- REVERSE : 해당 문자열을 순서를 반대로 바꿈 ( 한글은 지원하지 않음)
SELECT REVERSE('ABC')
FROM DUAL;

SELECT REVERSE(REVERSE('가나다'))
FROM DUAL;

-- TRANSLATE : 매칭되어있는 값으로 출력
SELECT TRANSLATE('010-3542-9465', '0123456789', '영일이삼사오육칠팔구')
FROM DUAL;

-- 단일행함수라서 결과가 해당되는 행의 개수만큼 나온다
SELECT EMP_NAME, EMP_NO, REVERSE(EMP_NO)
FROM EMPLOYEE;



-- 숫자 처리 함수
-- ABS : 절대값 
SELECT ABS(10), ABS(-10)
FROM DUAL;

-- MOD : 나머지를 구하는 함수
-- MOD(숫자, 나눌값)
SELECT MOD(3, 2)
FROM DUAL;

SELECT MOD(SALARY, 3)
FROM EMPLOYEE;

SELECT *
FROM EMPLOYEE
WHERE MOD(SALARY, 3) = 0;

-- 소수점처리
-- ROUND( 소수점자리 숫자, 자리수(생략가능) )
-- CEIL

SELECT ROUND(124.234), ROUND(124.675)
FROM DUAL;

SELECT ROUND(214.342, 1)
FROM DUAL;

-- 소수점을 0으로 기준삼아, 소수점뒷자리는 1, 2, .. 소수점 앞자리는 -1, -2, ...
SELECT ROUND(126.456, -1)
FROM DUAL;

-- FLOOR : 소수점 자리를 버림
SELECT FLOOR(123.456)
FROM DUAL;

SELECT FLOOR(1.456)
FROM DUAL;

-- TRUNC : 위치를 지정해서 버림
SELECT TRUNC(123.456)
FROM DUAL;

SELECT TRUNC(123.456, 2) -- 123.45 ( 소수점 두번째까지 남아았다)
FROM DUAL;

SELECT TRUNC(123.456), TRUNC(123.456, 2), TRUNC(123.456, 1),Trunc(123.456, -1)
FROM DUAL;

-- CEIL : 무조건 올림
SELECT CEIL(123.123), CEIL(122.123)
FROM DUAL;

SELECT EMP_NAME, FLOOR(SALARY+(SALARY * BONUS) / 3)
FROM EMPLOYEE;



-- 날짜 처리 함수 
-- SYSDATE : 시스템의 현재 날짜를 출력
SELECT SYSDATE 
FROM DUAL;

SELECT SYSDATE, CURRENT_DATE, LOCALTIMESTAMP, CURRENT_TIMESTAMP
FROM DUAL;

-- SYSDATE안에도 시분초가 들어있으나 출력할땐 날짜만 나온다
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
FROM DUAL;

-- 날짜도 산술연산이 가능하다
-- + / - 는 일자를 계산
SELECT SYSDATE-1 AS 어제, SYSDATE AS 오늘, SYSDATE +1 AS 내일
FROM DUAL;

-- 날짜끼리 계산 -> NUMBER타입의 일수(숫자)가 출력
SELECT SYSDATE-TO_DATE('01/02/24', 'YY/MM/DD')
FROM DUAL;

-- ADD_MONTH : 개월수를 연산해주는 함수( 개월 수 를 더해주는 함수 )
-- ADD_MONTHS(날짜, 더할 개월수)
SELECT ADD_MONTHS(SYSDATE, 3)
FROM DUAL;

-- EMPLOYEE테이블에서 입사 3개월 후 날짜를 구하세요
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 3)
FROM EMPLOYEE;

-- 오늘부로 상현씨가 군대로 끌려갑니당.... ㅋㅋㅋ
-- 군복무기간은 1년 6개월입니다. 전역날짜를 구하고, 전역까지 남은 짬밥의 수를 구하세요(하루 3끼)
SELECT ADD_MONTHS(SYSDATE, 18) AS 전역일, (ADD_MONTHS(SYSDATE, 18) -SYSDATE)*3 AS 짬밥수
FROM DUAL;

-- MONTHS_BETWEEN : 두 날짜 사이의 개월수를 구하는 함수 
-- MONTHS_BETWEEN(D1, D2)
SELECT MONTHS_BETWEEN(SYSDATE, TO_DATE('96/06/26', 'RR/MM/DD')) 
FROM DUAL;

-- EMPLOYEE 테이블에서 사원의 근무개월수를 구하세요
-- 이름 부서 직책 근무개월수 
SELECT EMP_NAME AS 사원명, DEPT_CODE AS 사원코드, JOB_CODE AS 직책, FLOOR(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) AS 근무일수
FROM EMPLOYEE;

-- NEXT_DAY : 날짜에 입력받은 요일에서 가장 가까운 요일의 날짜을 반환(지금부터 미래의 날짜)

SELECT SYSDATE, NEXT_DAY(SYSDATE, '월요일')
FROM DUAL;

SELECT NEXT_DAY(SYSDATE, '금') 
FROM DUAL;

-- LAST_DAY : 그 달의 마지막날을 출력
SELECT LAST_DAY(SYSDATE)
FROM DUAL;

-- 오라클은 한글 요일을 인식하네 ?? 왜?
-- 오라클은 LOCALE사용자에 대한 언어를 설정한다 
SELECT *
FROM V$NLS_PARAMETERS;

ALTER SESSION SET NLS_LANGUAGE = KOREAN;

SELECT SYSDATE, NEXT_DAY(SYSDATE, 'MON')
FROM DUAL;

SELECT SYSDATE, NEXT_DAY(SYSDATE, 'MONDAY')
FROM DUAL;

SELECT SYSDATE, NEXT_DAY(SYSDATE, 'FRIDAY')
FROM DUAL;

-- EXTRACT : 날짜의 년, 월, 일을 따로 출력할 수 있게
-- EXTRACT (YEAR FROM 날짜) : 년만 출력
-- EXTRACT (MONTH FROM 날짜) : 월만 출력
-- EXTRACT (DAY FROM 날짜) : 일만 출력
SELECT EXTRACT(YEAR FROM SYSDATE), EXTRACT(MONTH FROM SYSDATE), EXTRACT(DAY FROM SYSDATE)
FROM DUAL;

SELECT EXTRACT(HOUR FROM CAST(SYSDATE AS TIMESTAMP))
FROM DUAL;

SELECT EXTRACT(MINUTE FROM CAST(SYSDATE AS TIMESTAMP))
FROM DUAL;

SELECT EXTRACT(SECOND FROM CAST(SYSDATE AS TIMESTAMP))
FROM DUAL;

-- 입사일이 90년대인 사원의 이름 부서 입사일을 조회
SELECT EMP_NAME, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE EXTRACT(YEAR FROM HIRE_DATE) < 2000;
-- WHERE EXTRACT(YEAR FROM HIRE_DATE) BETWEEN 1900 AND 1999; 이렇게 써도 돼


-- 형변환 함수
-- 오라클은 데이터를 저장하기 위한 TYPE을 가지고 있음 
-- 숫자 : NUMBER : 정수와 소수점을 다 보관한다
-- 문자 : CHAR, VARCHAR2, NCHAR, NVARCHAR2 - VARCHAR2 사용을 권장
-- CHAR : 고정길이 

--CREATE TABLE TEST(
--    NAME CHAR(10),
 --   NAME VARCHAR2(10)
--)

-- 날짜 : DATE 


-- TO_CHAR(날짜형 숫자형 -> 문자형), TO_ DATE(문자형 숫자형 -> 날짜형), TO_NUMBER(문자형-> 숫자형)
-- TO_CHAR : DATE, NUMBER형 자료형을 CHARACTER형으로 변경하는것 
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD DAY HH24:MI:SS'), TO_CHAR(SYSDATE+1, 'YYYY/MM/DD (DY)')
FROM DUAL;

-- NUMBER형 -> CHARACTER형
SELECT TO_CHAR(12345, '999,999,999'), -- 9자리보다 작은 수가 들어오면 남은자릿수는 공백으로 표시
        TO_CHAR(12345, '9,999'), -- 이 패턴으로 변경이 안되니까 #####이 반환되었다 -> 형식을 더 큰 범위로 설정해야한다
        TO_CHAR(8500000, 'L999,999,999'), -- LOCAL기호 표시 -> 한국으로 설정했으니까 원화 표시가 뜬다
        TO_CHAR(912345, '000,000,000'), -- 빈 공간은 0으로 표시 
        TO_CHAR(123456, '000,000'), -- 자리수가 딱 맞으면 0으로 표시할 필요 없어짐
        TO_CHAR(80.5, '999,999.00'), -- 0으로 소수점자리수 표현 가능
        TO_CHAR(100, '999,999.00')
        
FROM DUAL;

-- EMPLOYEE테이블에서 급여를 이쁘게 출력해보세요
-- 사원명, 부서코드, 월급
SELECT EMP_NAME AS 사원명, DEPT_CODE AS 부서코드, TO_CHAR(SALARY, 'L999,999,999') AS 월급
FROM EMPLOYEE;

-- TO_DATE : 숫자, 문자를 날짜로 변경하는 함수
SELECT TO_DATE('19960626', 'YYYYMMDD')
FROM DUAL;

-- '96/06/26' > 날짜 : 대소비교 가능했던 이유 : 문자를 날짜로 자동형변환해서
SELECT TO_CHAR(TO_DATE('19981027', 'YYYYMMDD'), 'YYYY/MM/DD DAY HH24:MI:SS') -- '19981027'에 시간을 안넣었으니까 00:00:00 이 출력
FROM DUAL;

-- 시간까지 넣으면?
SELECT TO_CHAR(TO_DATE('19981027 14:18:15', 'YYYYMMDD HH24:MI:SS'), 'YYYY/MM/DD DAY HH24:MI:SS') 
FROM DUAL;

SELECT TO_DATE(19960925, 'YYYYMMDD')
FROM DUAL;

SELECT TO_DATE(960925, 'YYMMDD')
FROM DUAL;

SELECT TO_DATE(000225, 'YYMMDD') -- 에러
FROM DUAL;

SELECT TO_DATE('000225', 'YYMMDD')  -- 이렇게 고치면 된다.
FROM DUAL;

