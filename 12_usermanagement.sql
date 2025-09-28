-- 사용자 관리
-- 사용자 목록 조회
select * from mysql.user;

-- 사용자생성
create user 'jin1'@'%' identified by '1234'
docker로 들어갈 때는 % 사용
create user 'jin1'@'localhost' identified by '1234' -> 접속조차안됨

-- 사용자에게 권한 부여 : 특정 스키마와 테이블에 대해 부여
grant select on board.author to 'jin1'@'%'
grant select, insert on board.* to 'jin1'@'%'
grant all privileges on board.* to 'jin1'@'%'

-- 사용자 권한 회수
revoke select on board.author from 'jin1'@'%';
-- 사용자 권한 조회
show grants for 'jin1'@'%'

-- 사용자 계정 삭제
drop user 'jin1'@'%'