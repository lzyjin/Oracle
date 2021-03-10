
-- 0226

-- 배운 내용 : 제약조건




-- 제약조건 

-- NOT NULL : 데이터에 NULL을 허용하지 않음 
-- UNIQUE : 중복된값을 허용하지 않음 
-- PRIMARY KEY : 각 row들을 구분하기 위한 구분자, list의 인덱스같은 map의 key값같은 컬럼 (중복 안돼, null 안돼)
-- FOREIGN KEY : 다른테이블을 참조할 때, 
-- CHECK : 데이터의 범위나 조건을 지정해서 





-- 테이블에 제약조건 설정하기 

-- NOT NULL(C) 
-- 특정 컬럼에 NULL을 허용하지 않는것 -> DEFAULT설정이 되어있음 ( NULL이 무조건 뭐 ?)

-- UNIQUE(U) : 특정 컬럼에 중복된값을 허용하지 않음 -> 그러면 NULL은 어떻게 되는거야 ? 뒤에서 배운다 

-- 특정 컬럼에 조건을 주는 이유 :  컬럼이 변수같은 존재니까 

-- PRIMARY KEY(P) : 데이터를 구분하는 컬럼에 지정하는 제약조건으로, 기본키로 설정하면 NOT NULL와 UNIQUE가 자동으로 충족된다 
-- 보통 테이블에 1개를 지정한다 
-- 테이블에는 2개 이상의 PK가 존재할 수 없다 ( 최대 1개만 지정 가능 ) 

-- FOREIGN KEY(R) : 특정 컬럼에 다른테이블의 컬럼에 있는 값만 저장하게 하는 제약조건, 지정된 테이블의 컬럼은 유일해야한다.

-- CHECK(C) : 특정 컬럼의 값을 지정된 값만 저장할 수 있게 하는 특정문구나 범위를 설정 





-- DD를 이용해서 제약조건에 대한 정보를 확인하기
-- CONSTRAINT : 제약조건 
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE -- KH계정이 가지고 있는 테이블들의 설정되어있는 제약조건(이름, 타입) 확인  
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'EMPLOYEE'; -- 테이블 하나만 보려면 이렇게 

-- NULLABLE - YES : NULL 허용 / NO : NULL 비허용 

SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'EMPLOYEE';
-- 왼쪽부터 OWNER, CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME, SEARCH_CONDITION, R_OWNER ....
-- 어떤 종류의 제약조건이 어떤 테이블에 어떤 타입으로 적용되어있는지 알아야한다 

SELECT *
FROM USER_CONS_COLUMNS;
-- OWNER, CONSTRAINT_NAME, TABLE_NAME, COLUMN_NAME, POSITION 나옴 

-- 테이블에 대한 정보와 컬럼에 대한 정보까지 알고싶으면 JOIN할 것 
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, COLUMN_NAME
FROM USER_CONSTRAINTS 
    JOIN USER_CONS_COLUMNS USING(CONSTRAINT_NAME);












-- NOT NULL 제약조건 설정하기 

CREATE TABLE TBL_CONS_N( 
    USER_NO NUMBER,
    USER_ID VARCHAR2(20),
    USER_PWD VARCHAR2(30),
    USER_NAME VARCHAR2(30),
    GENDER VARCHAR2(30),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(30)
    -- 제약조건을 테이블레벨에서 설정
    -- CONSTRAINT 이름 UNIQUE (컬럼명) 
);

SELECT *
FROM TBL_CONS_N;

-- 테이블에 아무런 제약조건을 설정하지 않으면 
-- 테이블의 각 컬럼은 기본적으로 NULL값을 허용한다 
-- NULLABLE이 YES로 되어있다.

-- 확인해보기 위해 극단적으로 많이 넣어보자!
INSERT INTO TBL_CONS_N VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL);

SELECT *
FROM TBL_CONS_N;

-- 값 저장
INSERT INTO TBL_CONS_N VALUES(1, 'USER01', 'USER02', 'YEJIN', 'F', '010-4085-7209', '12-47@NAVER.COM');

SELECT *
FROM TBL_CONS_N;


-- 제약조건을 설정하는 방법 - 1. 컬럼레벨에서 2. 테이블레벨에서 
-- 1. 컬럼레벨에서 설정하는 방법 : 컬럼선언부 옆에 (, 끝나기전에 ) 
-- 2. 테이블레벨에서 설정하는 방법 : 컬럼선언이 다 끝나고 맨 끝에 작성하는 것 -> CONSTRAINT 예약어로 작성 

-- NOT NULL 제약조건은 컬럼레벨에서만 선언 가능 
-- 컬럼명 타입(길이) NOT NULL,

CREATE TABLE TBL_CONS_NN(
    -- CONSTRAINT USER_NO_NN 추가 -> 제약조건의 이름 ( 나중에 ALTER로 ...수정할 때 이 이름으로 하므로, 내가 알아보기 쉽게 이름을 붙여놓는것이 편하니까)
    USER_NO NUMBER CONSTRAINT USER_NO_NN NOT NULL, -- NOT NULL 제약조건을 설정
    USER_ID VARCHAR2(20) NOT NULL,
    USER_PWD VARCHAR2(20) NOT NULL,
    USER_NAME VARCHAR2(20),
    GENDER VARCHAR2(20),
    PHONE VARCHAR2(20), 
    EMAIL VARCHAR2(50)
);  

-- 테이블이름은 중복되면 안되므로 지우고 재생성합니당 
DROP TABLE TBL_CONS_NN;

SELECT *
FROM TBL_CONS_NN;

INSERT INTO TBL_CONS_NN VALUES(1, 'USER02', 'USER02', 'IU', 'F', '010-1234-1234', 'IU@GMAIL.COM');

SELECT *
FROM TBL_CONS_NN;

INSERT INTO TBL_CONS_NN VALUES(NULL, 'USER02', 'USER02', 'IU', 'F', '010-1234-1234', 'IU@GMAIL.COM');
-- 실행시 오류 발생 cannot insert NULL into ("KH"."TBL_CONS_NN"."USER_NO")

-- 회원가입시 필수입력항목이 NOT NULL인 것
-- 어플리케이션 실행을 위해 클라이언트에게 필수적으로 받아야 하는 데이터는 not null로 설정해야한다 

INSERT INTO TBL_CONS_NN VALUES(1, NULL, 'USER02', 'IU', 'F', '010-1234-1234', 'IU@GMAIL.COM');
-- 실행시 오류 발생 

INSERT INTO TBL_CONS_NN VALUES(1, 'USER03', 'USER03', 'IU', NULL, '010-1234-1234', 'IU@GMAIL.COM');
-- 행 삽입 가능 

SELECT *
FROM TBL_CONS_NN;

-- CONSTRAINT_NAME 제약조건을 부여하면 자동으로 부여되는 이름 
-- USER_NO NUMBER CONSTRAINT USER_NO_NN NOT NULL, 

-- 나중에 ALTER로 ...수정할 때 이 이름으로 하므로, 내가 알아보기 쉽게 이름을 붙여놓는것이 편하니까 









-- UNIQUE 
-- 지정된 컬럼에 중복값을 허용하지 않겠다 !
-- 컬럼레벨, 테이블레벨에서 둘다 설정 가능
SELECT *
FROM TBL_CONS_N;

INSERT TBL_CONS_N VALUES(2, 'USER2', 'USER2', 'IU', '010-1234-1234', 'IU@GMAIL.COM');


CREATE TABLE TBL_CONS_UQ( 
    USER_NO NUMBER,
    USER_ID VARCHAR2(20) UNIQUE , -- 아이디는 중복되면 안되니까 
    USER_PWD VARCHAR2(30),
    USER_NAME VARCHAR2(30),
    GENDER VARCHAR2(30),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(30)

);

SELECT *
FROM TBL_CONS_UQ;

INSERT INTO TBL_CONS_UQ VALUES(1, 'USER02', 'USER02', 'IU', 'F', '010-1234-1234', 'IU@GMAIL.COM');
INSERT INTO TBL_CONS_UQ VALUES(NULL, 'USER02', 'USER02', 'IU', 'F', '010-1234-1234', 'IU@GMAIL.COM');
INSERT INTO TBL_CONS_UQ VALUES(1, NULL, 'USER02', 'IU', 'F', '010-1234-1234', 'IU@GMAIL.COM');
INSERT INTO TBL_CONS_UQ VALUES(1, 'USER03', 'USER02', 'IU', NULL, '010-1234-1234', 'IU@GMAIL.COM');
-- ID가 중복되면 체이블에 들어갈 수 없다. 


-- 그렇다면 UNIQUE제약조건이 걸린 컬럼에서는 NULL을 어떻게 처리할까??
INSERT INTO TBL_CONS_UQ VALUES(4, NULL, 'USER02', 'IU', NULL, '010-1234-1234', 'IU@GMAIL.COM');
INSERT INTO TBL_CONS_UQ VALUES(5, NULL, 'USER02', 'IU', NULL, '010-1234-1234', 'IU@GMAIL.COM');
-- NULL을 동등비교 할 수 없어서 USER_ID가 NULL인 데이터가 몇번이고 삽입된다
-- 벤터회사마다 다름 

SELECT *
FROM TBL_CONS_UQ;


-- 테이블레벨에서 UNIQUE 제약조건 설정
CREATE TABLE TBL_CONS_UQ2(
    USER_ID VARCHAR2(20), 
    USER_PW VARCHAR2(20),
    CONSTRAINT USER_ID_UQ UNIQUE(USER_ID) 
);

DROP TABLE TBL_CONS_UQ2;

SELECT *
FROM TBL_CONS_UQ2;

INSERT INTO TBL_CONS_UQ2 VALUES('ADMIN', '1234');
INSERT INTO TBL_CONS_UQ2 VALUES('ADMIN', '5678');
-- 삽입 불가 


-- 한개 이상의 컬럼에 UNIQUE 설정하기 

CREATE TABLE TBL_CONS_UQ3(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20),
    USER_PW VARCHAR2(30),
    CONSTRAINT COM_NO_ID_UQ UNIQUE(USER_NO, USER_ID)
    -- 유니크 조건을 컬럼 따로따로 설정하고싶으면 그냥 따로 적으면 된다
    --UNIQUE
    --UNIQUE 
    --이렇게도 작성가능하지만 이럴거면 컬럼레벨에서 설정하는게 편하고 보기도 쉽다.
);
    
SELECT *
FROM TBL_CONS_UQ3;

INSERT INTO TBL_CONS_UQ3 VALUES(1, 'A', 'BMBH');
INSERT INTO TBL_CONS_UQ3 VALUES(1, 'B', 'BMBH');
INSERT INTO TBL_CONS_UQ3 VALUES(2, 'A', 'BMBH');
-- 둘다 오류없이 들어간다
-- 왜? USER_NO, USER_ID 두개를 그룹으로 묶어서 하나로 보고, 비교하기 때문에 
-- 하나의 컬럼이라도 다르면 중복값으로 처리하지 않는다. 

INSERT INTO TBL_CONS_UQ3 VALUES(1, 'A', 'BMBHHH');
-- 이건 오류 발생 unique constraint (KH.COM_NO_ID_UQ) violated











-- PRIMARY KEY 
-- 중복값이 없고, NULL값도 없는 컬럼에 설계자가 기본키로 지정함 
-- PRIMARY KEY가 설정되면 기본키로 설정하면 NOT NULL와 UNIQUE가 자동으로 설정된다
-- 한개의 테이블에 한개의 PRIMARY KEY만 설정 가능
-- 테이블레벨, 컬럼레벨에서 설정 가능

CREATE TABLE TBL_CONS_PK(
    USER_NO NUMBER PRIMARY KEY, -- ROW들에 번호 부여하는 컬럼 , 별 의미없는 컬럼 
    USER_ID VARCHAR2(20) UNIQUE,
    USER_PW VARCHAR2(20) NOT NULL,
    USER_NAME VARCHAR2(20)
);

SELECT *
FROM TBL_CONS_PK;

INSERT INTO TBL_CONS_PK VALUES(1, 'USER01', 'USER01', 'YEJIN');
INSERT INTO TBL_CONS_PK VALUES(2, 'USER02', 'USER02', 'LIZE');
INSERT INTO TBL_CONS_PK VALUES(2, 'USER03', 'USER03', 'JINI');
-- unique constraint (KH.SYS_C007072) violated

INSERT INTO TBL_CONS_PK VALUES(NULL, 'USER03', 'USER03', 'JINI');
-- cannot insert NULL into ("KH"."TBL_CONS_PK"."USER_NO")

INSERT INTO TBL_CONS_PK VALUES(3, 'USER03', 'USER03', 'JINI');
INSERT INTO TBL_CONS_PK VALUES(4, 'USER04', 'USER04', 'JINI2');
INSERT INTO TBL_CONS_PK VALUES(5, 'USER05', 'USER05', 'JINI2');

SELECT *
FROM TBL_CONS_PK
WHERE USER_NAME = 'JINI2';
-- 이름이 중복되니까 원하는 사람을 찾으려면 유일한 값으로 찾아야한다 -> 그게 PK 

SELECT *
FROM TBL_CONS_PK
WHERE USER_NO = 4;
-- PK로 찾음 

-- 테이블레벨에서 PK 설정 
CREATE TABLE TBL_CONS_PK2(
    USER_NO NUMBER, 
    USER_ID VARCHAR2(20) UNIQUE,
    USER_PW VARCHAR2(20) NOT NULL,
    USER_NAME VARCHAR2(20),
    CONSTRAINT USER_NO_PK PRIMARY KEY(USER_NO) 
);

SELECT *
FROM TBL_CONS_PK2;



-- PK 설정시 두개 이상의 컬럼을 PK 로 설정 가능 ( 복합키)
-- 장바구니 - 원하는 상품, 집어넣은 날짜, 아이디
-- 장바구니 테이블에 원하는 상품 아이디, 사용자 아이디를 넣어서 관리
-- -> 장바구니 테이블에 PK는 뭘로 설정해야 할까?
-- -> 제품과 사용자 아이디를 묶어서 PK로 하면 중복되지 않게 관리 할 수 있다. 상품개수가 많아져도 PK는 중복 안돼 
-- -> 복합키에 날짜까지 추가하면 다른날 장바구니에 물건을 담아도 저장가능 

CREATE TABLE TBL_ORDER(
    PRODUCT_NO NUMBER,
    USER_NO NUMBER,
    ORDER_DATE DATE,
    ORDER_NO NUMBER NOT NULL,
    PRIMARY KEY(PRODUCT_NO, USER_NO, ORDER_DATE)
    -- 이 3개의 컬럼이 같아야 동일한 데이터로 인식
);

INSERT INTO TBL_ORDER VALUES(11, 11, '21/02/26', 1);
INSERT INTO TBL_ORDER VALUES(11, 11, '21/02/26', 1);
-- unique constraint (KH.SYS_C007078) violated

INSERT INTO TBL_ORDER VALUES(11, 22, '21/02/26', 1);
-- 삽입 가능 

SELECT *
FROM TBL_ORDER;

INSERT INTO TBL_ORDER VALUES(11, NULL, '21/02/26', 1);
-- 세개의 컬럼을 한꺼번에 not null 설정할 수 없으므로 
-- 이 행은 삽입 가능 
-- 그래서 NOT NULL은 컬럼레벨에서만 설정해야한다. 









-- 외래키 : FORIGN KEY
-- 다른 테이블의 컬럼을 가져와 쓰는 것 
-- 부모 자식 관계로 설정된다. -> 이 관계 때문에 참조하고있는 테이블이 있다면 함부로 테이블을 삭제할 수 없다

-- 회원 정보 테이블 ( 부모 테이블 )
CREATE TABLE SHOP_MEMBER(
    USER_NO NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(20) UNIQUE NOT NULL, -- 하나의 컬럼에 제약조건 두개 설정 가능 (쉼표 없이 이어서 작성)
    -- USER_ID VARCHAR2(20) NOT NULL,
    USER_PW VARCHAR2(20) NOT NULL,
    USER_NAME VARCHAR2(20),
    GENDER VARCHAR2(10),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50)
);

DROP TABLE SHOP_MEMBER;
-- 이 테이블을 참조하는 테이블이 있어서 안지워짐 
-- 자식 테이블 먼저 지우고 지우면 됌 
DROP TABLE SHOP_BUY;

INSERT INTO SHOP_MEMBER VALUES(1, 'USER01', '1234', 'KYJ', 'F', '01012341234', 'KYJ@GMAIL.COM');
INSERT INTO SHOP_MEMBER VALUES(2, 'USER02', '2222', 'LJJ', 'F', '01016345234', 'LJJ@GMAIL.COM');
INSERT INTO SHOP_MEMBER VALUES(3, 'USER03', '3333', 'JHR', 'F', '01072295214', 'JHR@GMAIL.COM');
INSERT INTO SHOP_MEMBER VALUES(4, 'USER04', '4444', 'KSH', 'M', '01074364774', 'KSH@GMAIL.COM');
INSERT INTO SHOP_MEMBER VALUES(5, 'USER05', '5555', 'KTH', 'M', '01034545734', 'KTH@GMAIL.COM');

SELECT *
FROM SHOP_MEMBER;

-- 회원이 구매한 내역 테이블 ( 자식 테이블 ) 
CREATE TABLE SHOP_BUY(

    BUY_NO NUMBER PRIMARY KEY,
    
    --USER_ID VARCHAR2(20)NOT NULL REFERENCES SHOP_MEMBER(USER_ID),-- SHOP_MEMBER 테이블의 USER_ID를 가져와서 써야한다 - 참조 REFERENCES 키워드 사용 
    USER_ID VARCHAR2(20)NOT NULL,
    
    PRODUCT_NAME VARCHAR2(50),
    REG_DATE DATE,
    
    -- 테이블레벨에서 외래키 설정, 외래키에 이름지어줄 수 있음 
    CONSTRAINT USER_ID_FK FOREIGN KEY(USER_ID) REFERENCES SHOP_MEMBER(USER_ID)
);

-- 외래키를 설정하려면 부모테이블의 그 컬럼이 unique설정이 되어있거나 pk여야함 

DROP TABLE SHOP_BUY;
-- 회원정보 테이블과 회원구매내역테이블이 연결되어야한다
-- 회원아이디는 새로 받아서 저장하면 아예 다른 회원이 되니까, 회원정보에 저장되어있는 아이디를 이용해야 함 
-- -> 아이디를 외래키 
-- SHOP_BUY의 USER_ID(외래키)는 SHOP_MEMBER의 USER_ID(기본키)

SELECT *
FROM SHOP_BUY;

INSERT INTO SHOP_BUY VALUES(1, 'USER04', '술', SYSDATE);
INSERT INTO SHOP_BUY VALUES(2, 'YJ', '치킨', SYSDATE);
-- 오류 integrity constraint (KH.SYS_C007084) violated - parent key not found
-- SHOP_MEMBER의 기본키 (외래키)에 있는 아이디가 아닌 다른 아이디를 넣을 경우 오류 

INSERT INTO SHOP_BUY VALUES(2, NULL, '육포', SYSDATE);
-- NULL은 삽입 가능하네
-- NULL은 동등비교 불가능해서 그냥 넣어버림 
-- NULL도 안되게 하려면 SHOP_BUY테이블에서 USER_ID를 NOT NULL 조건을 걸어야함 
-- 그러면 위 코드는 삽입 안됌 

INSERT INTO SHOP_BUY VALUES(1, 'USER04', '술', SYSDATE);
INSERT INTO SHOP_BUY VALUES(2, 'USER01', '떡볶이', SYSDATE);
INSERT INTO SHOP_BUY VALUES(3, 'USER04', '육포', SYSDATE);
INSERT INTO SHOP_BUY VALUES(4, 'USER02', '커피', SYSDATE);




-- 회원이 구매한 내역 테이블 
CREATE TABLE SHOP_BUY(

    BUY_NO NUMBER PRIMARY KEY,
    
    --USER_ID VARCHAR2(20)NOT NULL REFERENCES SHOP_MEMBER(USER_ID),-- SHOP_MEMBER 테이블의 USER_ID를 가져와서 써야한다 - 참조 REFERENCES 키워드 사용 
    USER_ID VARCHAR2(20),
    
    PRODUCT_NAME VARCHAR2(50),
    REG_DATE DATE,
    
    -- 테이블레벨에서 외래키 설정, 외래키에 이름지어줄 수 있음 
    -- CONSTRAINT USER_ID_FK FOREIGN KEY(USER_ID) REFERENCES SHOP_MEMBER(USER_ID) ON DELETE SET NULL -- ON DELETE SET NULL 추가 ( 컬럼에 not null 이 있으면 안돼)
    CONSTRAINT USER_ID_FK FOREIGN KEY(USER_ID) REFERENCES SHOP_MEMBER(USER_ID) ON DELETE CASCADE

);

-- B테이블에서 A테이블의 컬럼을 외래키로 사용하려면(참조하려면), A테이블의 그 컬럼이 UNIQUE제약조건이 되어있거나 PK여야 한다. 

-- 외래키로 설정되어 있는 컬럼은 함부로 지우지 못하게 설정되어있음
-- 자식테이블 : SHOP_BUY
-- 자식테이블에서 부모테이블의 컬럼의 값을 가지고 있으면 부모테이블에서 그 값은 삭제가 불가능 
-- DELETE
DELETE
FROM SHOP_MEMBER 
WHERE USER_ID = 'USER04';
-- 오류 integrity constraint (KH.USER_ID_FK) violated - child record found
-- 지워버리면 자식테이블 바보된다구.... 

DELETE
FROM SHOP_MEMBER 
WHERE USER_ID = 'USER03';
-- SHOP_BUY에 USER03가 없으니까 부모테이블인 SHOP_MEMBER에서 삭제할 수 있다. 


-- 외래키 설정시 컬럼에 대한 삭제 옵션을 설정할 수 있다.
-- ~ ON DELETE SET NULL(회원의 구매이력)            /     ~ ON DELETE CASCADE (데이터의 종속관계) 
-- 부모테이블의 값이 삭제되면 자식테이블의 값은 null이 된다  /      참조된 자식테이블 전체가 다 지워진다 

 --CREATE TABLE SHOP_BUY(
-- CONSTRAINT USER_ID_FK FOREIGN KEY(USER_ID) REFERENCES SHOP_MEMBER(USER_ID) ON DELETE SET NULL -- ON DELETE SET NULL 추가 ( 컬럼에 not null 이 있으면 안돼)
-- CONSTRAINT USER_ID_FK FOREIGN KEY(USER_ID) REFERENCES SHOP_MEMBER(USER_ID) ON DELETE CASCADE

DROP TABLE SHOP_BUY;

INSERT INTO SHOP_BUY VALUES(4, 'USER02', '커피', SYSDATE);

SELECT *
FROM SHOP_BUY;

DELETE FROM SHOP_MEMBER 
WHERE USER_ID = 'USER02';
-- USER_ID 가 null이 되었다 

INSERT INTO SHOP_BUY VALUES(1, 'USER04', '테슬라', SYSDATE);

DELETE FROM SHOP_MEMBER 
WHERE USER_ID = 'USER04';
-- 데이터 자체가 사라졌다. 











-- CHECK 제약조건
-- 컬럼에 입력되는 값을 체크함
-- CHECK() 괄호안에 들어있는 값이 TRUE인것만 컬럼에 들어갈 수 있다. 
CREATE TABLE USER_CHECK(
    USER_NO NUMBER,
    USER_NAME VARCHAR2(20),
    GENDER VARCHAR2(10) CHECK(GENDER IN('남', '여')), -- GENDER가 '남' 또는 '여'만 들어갈 수 있음 
    AGE NUMBER,
    -- 테이블레벨에서 CHECK 조건 설정 ( 대소비교 가능 -> 결과가 true/false만 나오면 됌)
    CHECK(AGE > 19 AND USER_NO > 0)
);
    
DROP TABLE USER_CHECK;

INSERT INTO USER_CHECK VALUES(1, 'YHJ', 'M');
-- 오류 

INSERT INTO USER_CHECK VALUES(2, 'YHJ', '남', 18);
INSERT INTO USER_CHECK VALUES(2, 'KYJ', '여');

SELECT *
FROM USER_CHECK;

--TEST_MEMBER 테이블
-- MEMBER_CODE

CREATE TABLE TEST_MEMBER(
    CONSTRAINT 회원_전용_코드 MEMBER_CODE NUMBER PRIMARY KEY,
    CONSTRAINT 회원_아이디 MEMBER_ID VARCHAR2(20) UNIQUE,
    CONSTRAINT 회원_비밀번호 MEMBER_PWD CHAR(20) NOT NULL,
    CONSTRAINT 회원_이름 MEMBER_NAME NCHAR(10),
    CONSTRAINT 회원_거주지 MEMBER_ADDR CHAR(50) NOT NULL,
    CONSTRAINT 회원_성별 GENDER VARCHAR2(5) CHECK(GENDER IN('남', '여')),
    CONSTRAINT 회원_연락처 PHONE VARCHAR2(20) NOT NULL
);






