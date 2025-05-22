-- mariadb 서버에 접속
  mariadb -u root -p // 입력 후 비밀번호 별도 입력 (엔터를 치면서 들어가면 비번 마스킹)

* DDL
-- 스키마(DATABASE) 생성
  CREATE DATABASE board; --명령문은 대문자로 쓰는 것이 관례, 스키마의 이름은 보통은 소문자로
  create database board; --소문자로 써도 된다. 명령어의 경우 대소문자 관계없음.

-- 스키마 삭제
  drop database board;

-- 스키마(DATABASE) 목록 조회
  show databases;

-- 스키마 선택
  use 스키마명;

-- 문자 인코딩 변경
  ALTER database board default character set = utf8mb4; 
  //mb4 이모티콘이나 이런게 utf8에서 +됨

-- 문자 인코딩 조회
  show variables like 'character_set_server';

-- 테이블 생성
  create table author(컬럼1, 컬럼2, 컬럼3)
  create table author(id int primary key, name varchar(255), email varchar(255), password varchar(255));

  기본값은 "nullable"
  int값에 길이 제한을 안해도 할당되는 byte값은 똑같음, 1이든 3조든 (이진법 계산돼서)
  varchar는 한 문자당 2~4byte이므로 용량이 졸라 크기 때문에 길이제한
  길이제한 255 자주 함

-- 테이블 목록 조회
    show tables;
  
-- 테이블 컬럼 정보 조회
    describe 테이블명;

-- 테이블 생성 명령문 조회
  show create table 테이블명;

-- post 테이블 신규 생성 (id, title, contents, author_id)
  create table posts(id int primary key, title varchar(255), contents varchar(255), author_id int not null)
  create table posts(id int, title varchar(255), contents varchar(255), author_id int not null, primary key(id))
  fk 설정(author - posts)이 안돼 있기 때문에 만들어주자

  create table posts(id int, title varchar(255), contents varchar(255), author_id int not null, primary key(id), foreign key(author_id))
  이렇게만 해두면 될까? 어떤 테이블을 참고할 지 알려줘야 한다. foreign key 자체가 연관을 지어야 하는데
  참고할 수 있는 테이블이 어디인지 알아야 연관을 짓든 말든 하지 않겠나요??

  create table posts(
  id int,
  title varchar(255), 
  contents varchar(255), 
  author_id int not null, 
  primary key(id), 
  foreign key(author_id) references author (id)
  )

  **** fk는 참조하는 테이블에서 없는 데이터가 들어오면 안된다. ****

-- 테이블 제약 조건 조회
    SELECT * FROM information_schema.key_column_usage where table_name='posts'; 
    (* = all -> 모든 column을 조사한다)

-- 테이블 index 조회
  show index from author;
  ** 인덱스를 만들어줘야 하는 것은 빈번하게 조회되는 column.
  그래서 pk, fk의 경우 자동으로 index를 만들어준다.

-- alter : 테이블의 구조를 변경한다
 -- 테이블의 이름 변경
    alter table posts rename post;

 -- 테이블의 컬럼 추가
    alter table author add column age int; -> author 테이블에 int 타입 age 컬럼 추가

 -- 테이블의 컬럼 삭제
    alter table author drop column age; -> 위에서 만든 age 컬럼 삭제제

 -- 테이블 컬럼명 변경
    alter table posts change column contents content varchar(255);      **타입을 같이 써줘야 한다.

 -- 테이블 컬럼의 타입과 제약 조건 변경 (아주 많이 사용되는) => 덮어쓰기
    alter table author modify column email varchar(100) not null;
    alter table author modify column email varchar(100) not null unique; => "전부 풀로 다시 한 후"에 제약 조건 추가!!!
    not null , unique를 했다고 primary 가 아니라
    pk 가 not null unique

    -- 실습 : author 테이블에 address 컬럼을 추가 (varchar 255)
    alter table author add column address varchar(255);
    -- 실습 : post 테이블에 title은은 not null로 변경, content는 길이 3000자로 변경
    alter table posts modify title varchar(255) not null;
    alter table posts modify column content varchar(3000);

    alter table post modify column title varchar(255) not null, modify column content varchar(3000);

-- drop : 테이블을 삭제
    drop table abc;
    drop table if exists abc;
    일련의 쿼리를 실행시킬 때 특정 쿼리에서 에러가 나지 않도록 if exists를 많이 사용한다.


