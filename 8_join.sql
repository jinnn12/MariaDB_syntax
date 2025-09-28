-- post 테이블의 author_id 값을 nullable 하게 변경
alter table post modify author_id bigint; --> not null에서 nullable

-- inner join
-- 두 테이블 사이에 지정된 조건에 맞는 레코드만을 반환. on 조건을 통해 교집합 찾기
-- 즉, post 테이블의 글 쓴 적이 있는 author와 글쓴이가 author에 있는 post 데이터를 결합하여 출력
select * from author inner join post on author.id = post.author_id;
select * from author (as) a inner join post (as) p on a.id = p.author_id;
    -- 출력 순서만 달라질 뿐, 위 query 아래 query 모두 똑같다
select * from post p inner join author a on a.id = p.author_id;
-- 만약 같게 하고 싶다면, 
select a.*, p.* from post p inner join author a on a.id = p.author_id;

-- 글쓴이가 있는 글 전체 정보와 글쓴이의 이메일만 출력하시오.
-- post의 글쓴이가 없는 데이터는 제외, 글쓴이 중에 글 쓴 적 없는 사람도 제외
select p.*, a.email from post p inner join author a on p.author_id = a.id; (mine)
select p.*, a.email from post p inner join author a on a.id = p.author_id; (teachers)

select p.*, a.email
from post_2 p left join author_2 a on p.author_id = a.id;

select p.*, a.email from post p inner join author a on p.author_id=a.id;

-- 글쓴이가 있는 글의 제목, 내용, 그리고 글쓴이의 이름만 출력하시오
select p.title, p.contents, a.name from post p inner join author a on a.id = p.author_id;
select p.title, p.content, p.author from post p inner join author a on p.author_id=a.id;

-- A left join B : A 테이블 데이터 '모두' 조회하고, 관련있는 (ON) B 데이터도 출력.
-- A right join B : B 테이블 데이터 '모두' 조회하고, 관련있는 (ON) A 데이터도 출력.

-- 글쓴이는 모두 출력하되, 글을 쓴 적 있다면 관련 글도 같이 출력해라
select * from author a left join post p on a.id = p.author_id;

-- 모든 글 목록을 출력하고, 만약 저자가 있다면 이메일 정보를 출력해라
select p.*, a.email from post p left join author a on a.id = p.author_id; 

-- 모든 글 목록을 출력하고, 관련된 저자 정보 출력(author_id가 not null이라면)
-- 아래 두 쿼리 동일 (author_id가 not null)

select *
from post_2 p left join author_2 a on p.author_id=a.id
where p.author_id is not null;

select * from post p left join author a on p.author_id = a.id;
select * from post p inner join author a on p.author_id = a.id;

-- 실습) 글쓴이가 있는 글 중에서 글의 title, 저자의 email을 출력하되, 저자의 나이가 30세 이상인 글만 출력하겠다 (이건 where로 ㄱ)
select p.title, a.email from post p inner join author a on p.author_id = a.id WHERE a.age>=30;

-- 전체 글 목록을 조회하되, 글의 저자의 이름이 비어져 있지 않은 글 목록만을 출력 하시오.
select p.*
from post p left join author a on p.author_id=a.id
where p.author is not null;

select p.* from post p inner join author a on a.id=p.author_id where a.name is not null;

select p.* from post p left join author a on a.id=p.author_id where 

-- 조건에 맞는 도서와 저자 리스트 출력!
select b.book_id, a.author_name, b.published_date 
from book b inner join author a ON b.author_ID = a.ID where 

-- 없어진 기록 찾기
select * from outs o left join ins i on o.ANIMAL_ID = i.ANIMAL_ID WHERE i.ANIMAL_ID IS NULL;
select * from outs o where o.id not in (select id from ins)

엑셀표 보면서 inner join, left join 

-- union : 두 테이블의 select 결과를 횡으로 결합 (기본적으로 distinct가 적용된다.)
-- union시킬 때 컬럼의 개수와 컬럼의 타입이 같아야 함 name의 타입=title의 타입
select name, email from author union select title, content from post;
-- union all : 중복까지 모두 포함함
select name, email from author union all select title, content from post;

-- 서브 쿼리 : select문 안에 또 다른 select문을 서브쿼리라 함
select 컬럼 from 테이블 where 조건
  -- where절 안에 서브쿼리
  -- 한 번이라도 글을 쓴 author 목록 조회
  select distinct a.* from author a inner join post p on a.id=p.author_id;
  -- null 값은 in 조건에서 자동으로 제외
  select * from author where id in(select author_id from post)

  --컬럼 위치에 서브쿼리
   --author의 email과 author별로 본인의 쓴 글 개수 출력
    select email, (select count(*) from post p where p.author_=a.id) from author a   ;

  -- from절 위치에 서브쿼리
  select * from (select * from author where id>5) as a;

  -- group by 컬럼명 : 특정 컬럼으로 데이터를 그룹화하여 하나의 행처럼 취급
  select author_id from post group by author_id; --당연히 한 행밖에 나올게 없지. 게시글 여러개 쓴 경우는 어떡하니? 응?

  --보통 아래와 같이 집계함수와 같이 많이 사용
  select author_id, count(*) from post group by author_id;

  --집계함수
    --null은 count함수에서 제외된다.
  select count(*) from author; --not null 조건인 애들로 count해야 정확한 수치가 나오지 않을까?
  select sum(price) from post; --all을 넣으면 안되지 당연히 숫자로!
  select avg(price) from post; --all을 넣으면 안되지 당연히 숫자로!, 소숫점이 나올 가능성이 높으므로 round
  select round(avg(price), 3) from post --> 소수 3번째 자리에서 반올림

  -- group by와 집계함수
  select author_id, count(*), sum(price) from post group by author_id

  -- where와 group by
  -- 날짜별 포스트 글의 개수 출력, null은 제외
  select DATE_FORMAT(created_time, '%Y-%m-%d'), count(*)
  from post where created_time is not null 
  group by DATE_FORMAT(created_time, '%Y-%m-%d');
 ==
  select DATE_FORMAT(created_time, '%Y-%m-%d') as day, count(*)
  from post where created_time is not null 
  group by day;

  -- 자동차 종류별 특정 옵션이 포함된 자동차 수 구하기
  -- 입양 시각 구하기(1)

  -- group by와 having
  -- having은 group by를 통해 나온 집계값에 대한 조건
    -- 글을 2번 이상 쓴 사람 ID 찾기
    select author_id, count(*) from post group by author_id having count(*) >= 2;
    select author_id from post group by author_id having count(*) >= 2;
    
    -- 동명 동물 수 찾기
    -- 카테고리 별 도서 판매량 집계하기
    -- 조건에 맞는 사용자와 총 거래금액 조회하기

    -- 다중열 GROUP BY 
                GROUP BY A, B 하면 A, B 모두 SELECT에 써야 함
    -- group by 첫번째컬럼, 두번째컬럼 : 첫번째컬럼으로 먼저 grouping 이후에 두번째컬럼으로 grouping
    -- post테이블에서 작성자 별로 만든 제목의 개수를 출력하세요
    select author_id, title, count(*) from post group by author_id, title;
    -- 재구매가 일어난 상품과 회원 리스트 구하기
