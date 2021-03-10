
-- SQL05_DML

-- 1
SELECT *
FROM TB_CLASS_TYPE;

INSERT INTO TB_CLASS_TYPE VALUES('01,', '전공필수');
INSERT INTO TB_CLASS_TYPE VALUES('02,', '전공선택');
INSERT INTO TB_CLASS_TYPE VALUES('03,', '교양필수');
INSERT INTO TB_CLASS_TYPE VALUES('04,', '교양선택');
INSERT INTO TB_CLASS_TYPE VALUES('05,', '논문지도');

SELECT CLASS_TYPE_NO AS 번호, CLASS_TYPE_NAME AS 유형이름
FROM TB_CLASS_TYPE;



-- 2
CREATE TABLE TB_학생일반정보 AS SELECT STUDENT_NO AS 학번, STUDENT_NAME AS 학생이름, STUDENT_ADDRESS AS 주소
                            FROM TB_STUDENT;
                            
SELECT *
FROM TB_학생일반정보;


-- 3

SELECT *
FROM TB_STUDENT;


CREATE TABLE TB_국어국문학과 AS SELECT DISTINCT STUDENT_NO AS 학번, 
                                    STUDENT_NAME AS 학생이름,
                                    EXTRACT(YEAR FROM (TO_DATE( SUBSTR(STUDENT_SSN, 1, 6), 'RR/MM/DD' ) ) ) AS 출생년도,
                                    PROFESSOR_NAME AS 교수이름
                            FROM TB_STUDENT 
                                JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
                                JOIN TB_PROFESSOR USING(DEPARTMENT_NO) 
                            WHERE DEPARTMENT_NAME = '국어국문학과';
                            
-- 답지
CREATE TABLE TB_국어국문학과(학번, 학생이름, 출생년도, 교수이름)
AS SELECT STUDENT_NO, STUDENT_NAME, TO_CHAR(TO_DATE(SUBSTR(STUDENT_SSN, 1, 6)), 'YYYY/MM/DD'), NVL(PROFESSOR_NAME, '지도교수 없음')
   FROM TB_STUDENT S
        LEFT JOIN TB_PROFESSOR ON (PROFESSOR_NO = COACH_PROFESSOR_NO)
        LEFT JOIN TB_DEPARTMENT D ON(D.DEPARTMENT_NO = S.DEPARTMENT_NO)
   WHERE DEPARTMENT_NAME = '국어국문학과';
                            
SELECT *
FROM TB_국어국문학과
ORDER BY 학생이름;
        
DROP TABLE TB_국어국문학과;
        
                            
SELECT *
FROM TB_STUDENT 
    JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
    JOIN TB_PROFESSOR USING(DEPARTMENT_NO);
--WHERE DEPARTMENT_NAME = '국어국문학과'
--ORDER BY 2;
                                    
SELECT *
FROM TB_DEPARTMENT
    JOIN TB_PROFESSOR USING(DEPARTMENT_NO)
ORDER BY DEPARTMENT_NAME;


-- 4
SELECT *
FROM TB_DEPARTMENT;

UPDATE TB_DEPARTMENT SET CAPACITY = ROUND(CAPACITY*1.1);

ROLLBACK;

SELECT *
FROM TB_DEPARTMENT;


-- 5
SELECT *
FROM TB_STUDENT;

UPDATE TB_STUDENT SET STUDENT_ADDRESS = '서울시 종로구 숭인동 181-21 ' WHERE STUDENT_NO = 'A413042';


-- 6
-- ALTER TABLE TB_STUDENT MODIFY STUDENT_SSN VARCHAR2(6);
UPDATE TB_STUDENT SET STUDENT_SSN = SUBSTR(STUDENT_SSN, 1, 6);

SELECT *
FROM TB_STUDENT;

DESC TB_STUDENT;

ROLLBACK;



-- 7
SELECT *
FROM TB_STUDENT
    JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
    JOIN TB_GRADE USING(STUDENT_NO)
    JOIN TB_CLASS USING(DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '의학과' 
    AND STUDENT_NAME = '김명훈' 
    AND CLASS_NAME = '피부생리학'
    AND TERM_NO = '200501';
    
    
-- 이게 푼 것    
UPDATE TB_GRADE SET POINT = 3.5 WHERE TERM_NO = (SELECT TERM_NO    
                                                        FROM TB_GRADE
                                                            JOIN TB_STUDENT USING(STUDENT_NO)
                                                            JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
                                                            JOIN TB_CLASS USING(DEPARTMENT_NO)
                                                        WHERE DEPARTMENT_NAME = '의학과' 
                                                            AND STUDENT_NAME = '김명훈' 
                                                            AND CLASS_NAME = '피부생리학'
                                                            AND TERM_NO = '200501');
                                                                                                                   
ROLLBACK;

-- 다시 품
UPDATE TB_GRADE SET POINT = 3.5 WHERE STUDENT_NO = (SELECT STUDENT_NO
                                                           FROM TB_GRADE
                                                            JOIN TB_STUDENT USING(STUDENT_NO)
                                                            JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
                                                            JOIN TB_CLASS USING(DEPARTMENT_NO)
                                                        WHERE DEPARTMENT_NAME = '의학과' 
                                                            AND STUDENT_NAME = '김명훈' 
                                                            AND CLASS_NAME = '피부생리학'
                                                            AND TERM_NO = '200501');
 
-- 다시 풀었는데 정답입니다.                                                             
UPDATE TB_GRADE 
SET POINT = 3.5  
WHERE TERM_NO = '200501' 
    AND STUDENT_NO = (SELECT DISTINCT STUDENT_NO 
                     FROM TB_GRADE
                        JOIN TB_STUDENT USING(STUDENT_NO)
                        JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
                        WHERE STUDENT_NAME = '김명훈' AND DEPARTMENT_NAME = '의학과');
                                
SELECT *
FROM TB_GRADE
    JOIN 
WHERE TERM_NO = '200501' AND 



-- 8
SELECT STUDENT_NAME, ABSENCE_YN
FROM TB_GRADE
    JOIN TB_STUDENT USING(STUDENT_NO)
WHERE ABSENCE_YN = 'Y';

DELETE FROM TB_GRADE WHERE STUDENT_NO IN(SELECT STUDENT_NO
                            FROM TB_STUDENT
                            WHERE ABSENCE_YN = 'Y');

DELETE FROM TB_GRADE WHERE ABSENCE_YN = 'Y';

ROLLBACK;

DESC TB_STUDENT;

SELECT *
FROM TB_STUDENT;
    
    
SELECT *
FROM TB_GRADE;
