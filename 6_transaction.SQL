-- 트랜잭션 테스트
  alter table author add column post_count int default 0;

-- post에 글 쓴 후, author 테이블의 post_count 컬럼에 +1을 시키는 트랜잭션 테스트
// 0) 임시저장 1)commit 2)rollback
start transaction;
update author set post_count=post_count+1 where id = 3
insert into post(title, content, author_id) values("hello", "hel1oo", 3);
commit ; -- 또는 rollback;

start transaction;
update author set post_count=post_count+1 where id = 3
insert into post(title, content, author_id) values("hello", "hel1oo", 100);
commit ;
-- 위 트랜잭션은 실패시 자동으로 rollback 안됨. 12라인에서 끝, update만 임시저장!
-- stored 프로시저를 활용하여 성공시 commit, 실패시 rollback 등 다이나믹한 프로그래밍 가능
DELIMITER //
CREATE PROCEDURE TRANSACTION_TEST()
BEGIN
  declare exit handler for SQLEXCEPTION
  BEGIN
    rollback;
  END; --sqlexception이 발생하면 rollback을 실행하겠다!
  start transaction;
  update author set post_count=post_count+1 where id = 3;
  insert into post(title, content, author_id) values("hello", "hel1oo", 3);
  commit ;
END //
DELIMITER ;

call TRANSACTION_TEST;
select *  from author -> ㅇㅇ

-- 프로시저 호출
DELIMITER //
create procedure transaction_test2(in titleInput varchar(255), in contentInput varchar(255), in idInput bigint)
BEGIN
  declare exit handler for SQLEXCEPTION
  BEGIN
    rollback;
  END;
  start transaction;
  update author set post_count=post_count+1 where id = idInput;
  insert into post(title, content, author_id) values(titleInput, contentInput, idInput);
  commit ;
END //
DELIMITER ;

-- 사용자에게 입력 받는 프로시저 생성