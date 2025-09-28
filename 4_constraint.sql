-- not null 제약조건이 없을 때 추가하는 방법
  alter table author modify column name varchar(255) not null;
-- not null 제약조건 제거
  alter table posts modify column name varchar(255);
-- not null, unique 제약조건 동시 추가
alter table author modify column name varchar(255) not null unique;

-- 테이블 차원의 제약조건 (pk, fk) 추가/제거
SELECT * FROM information_schema.key_column_usage where table_name='posts'; 
- 조회

-- 제약조건 삭제 (fk)
alter table posts drop foreign key 제약조건명; (권고)
alter table posts drop constraint 제약조건명;
-- 제약조건 삭제 (pk)
alter table posts drop primary key;
-- 제약조건 추가
alter table posts add constraint 제약조건명(post_pk) primary key(id);
alter table post add constraint post_fk foreign key(author_id) references author(id)

-- ON DELETE, ON UPDATE 제약 조건 테스트
-- 부모테이블 DELETE시 SET NULL 자식 FK 컬럼 SET NULL, UPDATE시 자식 FK컬럼 CASCADE
alter table post add constraint 
제약조건명(post_fk_new) foreign key(author_id) references author(id) 
on delete set null on update cascade;

-- default 옵션
-- enum타입 및 현재시간(current_timestamp)에서 많이 사용, 입력 안했을 때 anonymous로 들어감
alter table author modify column name varchar(255) default 'anonymous';

-- auto_increment 
--입력을 안했을 때, 마지막에 입력된 가장 큰 값에서 +1만큼 자동으로 증가된 숫자값을 적용하겠다.
alter table author modify column id bigint auto_increment
alter table post  modify column id auto_increment
// pk와 부합한다! 자동으로 하나씩 증가되면 unique에 위배되지도 않고, not null도 아님

-- uuid 타입
alter table post add column user_id char(36) default (uuid());

