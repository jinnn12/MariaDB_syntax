-- insert, into, values : 테이블에 데이터 삽입
  insert into 테이블명 (컬럼1, 컬럼2, 컬럼3) values (데이터1, 데이터2, 데이터3)
  insert into author (id, name, email) values (3, 'hong3', 'hong3@naver.com'); --문자열은 일반적으로 '' 작은 따옴표 사용용

-- update, set : 테이블에 데이터 변경
  update author set name="홍길동", email="hong100@naver.com" where id=3;

-- select : 조회
  select 컬럼1, 컬럼2 (혹은 전부가 하고 싶다면 *) from 테이블명;
  select name, email from author;
  select * from author;

-- delete : 삭제제
  delete from 테이블명 where 조건절;
  delete from author where id=3;
  보통 where 뒤에는 pk가 많이 사용된다, 특정 지을 수 있는 연산자라서.


-- select 조건절 활용 조회
-- 테스트 데이터 삽입
-- insert 문을 활용해서 author데이터 3개, posts데이터 5개
  author 데이터 추가, posts 데이터 추가

select * from author;
select * from author where id=1; -- where 뒤에 조회 조건을 통해 필터링
select * from author where name='hong1'; 
select * from author where id>3; -- id가 4번 이상인 데이터를 조회
select * from author where id>3 and name='hong4';
select * from author where id>3 or;

-- 중복 제거 조회 : distinct
select name from author;
select distinct name from author;

-- 정렬 : order by + 컬럼명
  -- asc : 오름차순, desc : 내림차순, 안 붙이면 오름차순이 (default)
  -- 아무런 정렬조건 없이 조회할 경우엔 pk 기준으로 오름차순
select * from author order by name; (디폴트인 오름차순)
select * from author order by name desc; (desc는 붙여줘야 내림차순)

-- 멀티 컬럼 order by : 여러 컬럼으로 정렬 시, 먼저 쓴 컬럼 우선정렬
                    --  중복 시, 그 다음 정렬 옵션 적용
select * from author order by name desc;
  select * from author order by name desc, email asc;
                      
-- 결괏값 개수 제한
select * from author limit 1; (pk 기준으로 order by가 되어 있으니 가장 앞에 있는 id 값값이 나옴)
select * from author order by id desc limit 1; (id가 오름차순으로 오래된 것이라면 가장 최신의 것이 출력되겠죠?)

-- 별칭(alias)을 이용한 select
select name as '이름', email as '이메일' from author;
영어가 한 글 로 ?!
select name, email from author as a; -- author를 a로 여긴다.
select a.name, a.email from author as a;
 나중에 조인 했을 때 너무 길어지는 걸 방지하기 위함.
select a.name, a.email from author a; -- 이것도 가능~~

-- null을 조회 조건으로 활용 (예를들면 비밀번호 없는 유저를 찾아라)
select * from author where password is null; -- thing is null
select * from author where password is not null; 

-- 프로그래머스 sql 문제풀이
-- 여러 기준으로 정렬하기
-- 상위 N개 레코드
