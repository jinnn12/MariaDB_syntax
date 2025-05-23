-- TINYINT : (-128 ~ 127까지 표현)
-- AUTHOR 테이블에 age 컬럼 변경
alter table author modify column age tinyint unsigned;
insert into author(id, email, age) values(6, "agc@naver.com", 200);
select * from author;
describe author;

-- int : 4바이트 (약 40억, 숫자범위)
-- BIGINT : 8바이트 (더더 큼)
-- AUTHOR, POST 테이블의 ID값 BIGINT 변경
alter table author modify column id bigint primary key;

-- DECIMAL (총 자릿수, 소수부 자릿수)
alter table posts add column price decimal(10, 3);
insert into post(id, title, price, author_id);


-- 문자 타입 : 고정 길이 (char), 가변 길이 (varchar, text)
alter table author add column gender char(10); //M or W
alter table author add column self_introduction text;

-- BLOB (바이너리 데이터, 이진법 체계 -> 눈에 보이는 건 16진법)\ 잘 안 씀 비효율이라라
-- 일반적으로 blob으로 저장하기 보다, varchar로 설계하고 이미지경로만을 저장함.
alter table author add column profile_image longblob;
insert into author(id, email, profile_image) values (8, 'abc@naver.com', LOAD_FILE('"C:\\bauhaus.jpg"'))
-> LOAD_FILE 는 경로 저장 함수

-- enum : 삽입될 수 있는 데이터의 종류를 한정하는 데이터 타입
-- role컬럼 추가
  -- enum에 지정된 값이 아닌 경우
  alter table author add column role enum('admin', 'user');
  -- role을 지정 안 한 경우
  alter table author add column role enum('admin', 'user') not null default 'user';
  role 값을 안 넣으면, 당연히 user 겠지. 값 안 넣으면 null이 안 생기고 user로 도배가 됨..
  defualt >> 날짜, role 등등....^^
  -- enum에 지정된 값인 경우
  insert into author(id, email, role) values(10, 'ddd@naver.com', 'hello');

-- date와 datetime
-- 날짜타입은 입력, 수정, 조회 시에 문자열을 사용 ''
alter table author add column birthday date;
alter table posts add column created_time datetime;

insert into posts(id, title, author_id, created_time) values (7, 'hellon', 3, '2025-05-23 14:36:39');

alter table posts modify column created_time datetime default current_timestamp();
* current_timestamp 는 시간 입력을 안하면 내가 현재시간 찍겠다.
이후 insert ㄱㄱ

-- 비교 연산자
select * from author where 2 <= id && id <= 4
select * from author where id between 2 and 4 (위 구문과 같은 구문이다.) / 잘 안 씀

select * from author where id in(2, 3, 4);
select * from author where id not in(2, 3, 4);

-- like : 특정 문자를 포함하는 데이터를 조회하기 위한 키워드
select * from author where name like '홍%';
select * from author where name like '%동';
select * from author where name like '%길%';

select * from posts where title like 'hel%';
select * from posts where title like '%hel';
select * from posts where title like '%hel%';

-- regexp : 정규 표현식을 활용한 조회
select * from post where title regexp '[a-z]' --하나라도 알파벳 소문자가 들어 있으면
select * from post where title regexp '[가-힣]' --하나라도 한글이 있으면면

--숫자 -> 날짜
select cast(20250523 as date); -- 2025-05-23

--문자 -> 날짜
select cast('20250523' as date); -- 2025-05-23

--문자 -> 숫자
select cast('12' as unsigned);

-- 날짜조회 방법
-- like 패턴, 부등호 활용, date_format
select * from posts where created_time like '2025-05%'; --문자열처럼 조회
select * from posts where '2025-05-01' <= created_time and created_time < '2025-05-21'
  --> 2025-05-01 ~ 2025-05-20 만 조회 가능! 끝자리는 <= 하면 안된다~~
      원리는 날짜만 입력시 '2025-05-01 00:00:00' <= time <= '2025-05-21 00:00:00'으로 처리가 됨됨



select * from posts where date_format(created_time, '%Y');
select * from posts where date_format(created_time, '%m') = '05';
select * from posts where creted_time like '%05%' 위엣엣 것과 이 둘의 차이점은 월만 뽑을 수 있냐, 문자열을 기준으로 뽑냐 의 차이!
select * from posts where date_format(created_time, '%d'); -- dateformat 함수

select date_format(created_time, '%Y-%m-%d') from posts; --년 월 일 기준
select date_format(created_time, '%H:%i:%s') from posts; --시간 분 초 기준

깔끔하게 하고 싶으면 as
select date_format(created_time, '%Y-%m-%d') as 'date' from posts;
select date_format(created_time, '%H:%i:%s') as 'time' from posts

select * from post where date_format(crated_time, '%m') = '05';

select * from post where cast(date_format(crated_time, '%m') as unsigned) = 5;
--cast 함수를 사용하여 숫자값으로 바꿀 수 있다. 문제에서 나올듯?






select * from author;
alter table author modify column id bigint;
describe aut]]]]hor;

select * from posts;
describe posts;

SELECT * FROM information_schema.key_column_usage where table_name='posts'; 
alter table posts drop constraint posts_ibfk_1;

alter table author modify id bigint;
alter table posts modify id bigint;
alter table posts modify author_id bigint;
alter table posts add constraint posts_ibfk_1 foreign key(author_id) references(id);


