-- 0217 수요일
SELECT * FROM DICT;
-- 오라클db에 대한 정보를 가지고 있는 테이블 : DATA DICTIONARY 라고 한다

SELECT * FROM DICTIONARY;

-- 현재 db에 등록된 사용자계정 정보를 보기
SELECT * FROM DBA_USERS;

-- 계정은 관리자 계정과 사용자 계정으로 나누어진다
-- 관리자 계정은 사용자 계정을 등록하고 권한을 부여하며, 생성된 전체 TABLE을 관리하는 역할 -> DATABASE를 전체적으로 관리
-- SYSTEM : 일반관리자 : 데이터베이스 자체를 생성하거나 삭제할 수 없다.
-- SYS : 슈퍼관리자 : 데이터베이스를 생성, 삭제, DATA DICTIONARY의 소유자 (최고 관리자)

-- 기본적으로 오라클 DATABASE를 이용하기 위해서는 사용자계정이 필요하다.
-- 사용자계정 만들기 -> 계정 생성 후 그 계정에 대한 이용 권한 부여 까지 해야 이용할 수 있다.
-- 사용자계정은 SYSTEM이나 SYS AS SYSDBA 계정으로 명령어를 작성해야한다.
-- CREATE USER 유저명 IDENTIFIED BY 비밀번호
CREATE USER KH IDENTIFIED BY KH;
SELECT * FROM DBA_USERS;
-- 사용자 계정은 CREATE로 생성한다고 해서 무조건 DB이용이 가능한것이 아니다.
-- 이용할 수 있는 권한을 SYSTEM/SYS계정이 부여해주어야 한다.
-- GRANT 권한명(ROLE) TO 사용자계정명;
-- 사용자가 등록되면 
-- 1. RESOURCE, CONNECT권한(ROLE)을 부여한다
GRANT RESOURCE, CONNECT TO KH;

-- 명령어 외우기 
-- 숙제 : 사용자 계정 만들고 테스트 해보고 접속해보기 

