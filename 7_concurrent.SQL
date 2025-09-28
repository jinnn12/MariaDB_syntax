-- read uncommited : commit 되지 않은 데이터 read 가능 -> dirty read 문제 발생
  -- (가장 낮은 격리 수준, 다 허용된다)
-- 실습 절차
-- 1) 워크벤치에서 auto_commit 해제. update 후 commit 하지 않음 (transaction 1)
-- 2) 터미널을 열어 selecet 했을 때 위 변경사항이 읽히는 지 확인 (transaction 2) => 접속 툴이 달라지면 다른 트랜잭션으로 간주한다.
-- 결론 : mariaDB는 기본이 repeatable read이므로 dirty read 발생하지 않음.

-- read commited : commit한 데이터만 read 가능 -> phantom read(갑자기 insert 뭐가 튀어나옴) 발생 가능 (또는 non-repeatable read), 조회에 일관성이 보장되지 않는다.
-- 워크벤치에서 실행
start transaction;
select count(*) from author;
do sleep(15)
select count(*) from author;
commit;
-- 터미널에서 실행
insert into author(email) values("XXX@naver.com");


-- repeatable read : 읽기의 일관성 보장(phantom read 해결) -> 
  --lost update 문제 발생 -> 
  --배타적 잠금(=select for update, select 할 때부터 lock, 다른 트랜잭션을 배제)으로 해결

--lost update 문제 발생
DELIMITER //
CREATE PROCEDURE concurrent_TEST1()
BEGIN
  declare count int;
  start transaction;
  insert into post(title, author_id) values ('helloworld', 1);
  select post_count into count from author where id=1;
  do sleep(15);
  update author set post_count=count+1 where id=1;
  commit ;
END //
DELIMITER ;
-- 터미널에서는 아래 코드 실행
  select post_count from author where id=1;

--lost update 문제 해결 : select for update시에 트랜잭션이 종료 후에 특정 행에 대한 lock이 풀림
DELIMITER //
CREATE PROCEDURE concurrent_TEST2()
BEGIN
  declare count int;
  start transaction;
  insert into post(title, author_id) values ('helloworld', 1);
  select post_count into count from author where id=1 for update;
  do sleep(15);
  update author set post_count=count+1 where id=1;
  commit ;
END //
DELIMITER ;
// for update 이후 락을 걸어버린다. 즉 특정 행에 대해서 
-- 터미널에서는 아래 코드 실행
  select post_count from author where id=1 for update;
  
  --결론 짓자면 A(mariadb)에서 실행된 트랜잭션이 끝나야만 B(터미널)에서 실행한 값이 저장이 된다.
  --select (조회) 하는 부분에서 걸림돌이 되는데, 0이라고 가정했을 때 A, B 두 부분에서 
  --insert를 하게 되면, 둘 다 0으로 읽고 +1을 하게 된다. 
  --A에서도 insert +1, B에서도 insert +1 총 +2가 돼야 하는데, 
  --둘 다 0으로 읽고 +1로 해서 동시성 오류가 발생한다. 
    --이를 A 트랜잭션에서 먼저 실행 하고 B 트랜잭션이 동작하게 끔


-- serializable : 모든 트랜잭션 순차적 실행 -> 동시성 문제 없음! but 성능저하



on a:id = p.author_id
left join--> 무조건