-- 테이블 삽입 : 드래그앤 드롭 -> fn + f5 

SELECT *
FROM TAB;

-- [ Basic SELECT] 

-- 1. 춘 기술대학교의 학과 이름과 계열을 표시하시오
SELECT DEPARTMENT_NAME AS "학과 명", CATEGORY AS 계열
FROM TB_DEPARTMENT;

-- 2. 학과의 학과 정원을 출력
SELECT CONCAT(DEPARTMENT_NAME, '의 정원은 ')|| CONCAT(CAPACITY, '명 입니다.') AS "학과별 정원"
FROM TB_DEPARTMENT;

-- 3. "국어국문학과"에 다니는 여학생 중 현재 휴학중인 여학생을 찾아달라는 요청이 들어왔다. 누구인가? 
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE DEPARTMENT_NO = '001' AND SUBSTR(STUDENT_SSN, 8, 1) = '2' AND ABSENCE_YN = 'Y';



SELECT *
FROM TB_DEPARTMENT;

-- 4. 도서관에서 대출 도서 장기 연체자들을 찾아 이름을 게시하고자한다.
-- 그 대상자들의 학번이 다음과 같을 때 대상자들을 찾는 적절한 SQL 구문을 작성하시오
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE STUDENT_NO IN('A513079', 'A513090', 'A513091', 'A513110', 'A513119')
ORDER BY STUDENT_NAME DESC;

-- 5. 입학정원이 20명 이상 30명 이하인 학과들의 학과이름과 계열을 출력하세요
SELECT DEPARTMENT_NAME, CATEGORY
FROM TB_DEPARTMENT
WHERE CAPACITY >= 20 AND CAPACITY <= 30;

-- 6. 춘 기술 대학교는 총장 제외하고 모든 교수들이 소속학과를 가지고 있다. 
-- 그럼 춘기술대학교의 총장의 이름을 알아낼 수 있는 SQL문장을 작성하시오
SELECT PROFESSOR_NAME
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO IS NULL;

-- 7. 혹시 전산상의 착오로 학과가 지정되어 있지 않은 학생이 있는지 확인하고자 한다.
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE DEPARTMENT_NO IS NULL;

-- 8. 수강신청 -> 선수과목 여부 확인 -> 선수 과목이 존재하는 과목들은 어떤 과목인지 과목번호를 조회
SELECT CLASS_NO
FROM TB_CLASS
WHERE PREATTENDING_CLASS_NO IS NOT NULL;

-- 9. 춘 대학에는 어떤 계열이 있는지
SELECT DISTINCT(CATEGORY)
FROM TB_DEPARTMENT;

-- 10. 02학번 전주 거주자들의 모임을 만들려고 한다. 휴학한 사람들은 제외하고 재학중인 학생들의 학번, 이름, 주민번호를 출력
SELECT STUDENT_NO, STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE SUBSTR(STUDENT_ADDRESS, 1, 3) = '전주시' AND ABSENCE_YN = 'N' AND SUBSTR(TO_CHAR(ENTRANCE_DATE), 1, 2) = '02'
ORDER BY STUDENT_NAME;


