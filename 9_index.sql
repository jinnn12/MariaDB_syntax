-- pk, fk, unique 제약조건 추가 시에 해당 컬럼에 대해 index 자동 생성 --
-- index가 만들어지면 조회 성능 향상, insert update delete 성능 하락

-- index 조회
show index from author;

-- index 삭제
alter table author drop index 인덱스이름

-- index 생성
create index 인덱스이름 on 테이블(컬럼명),
  --어떤 컬럼에다가 지정하는 것임

-- index를 통해 조회 성능 향상을 얻으려면 반드시 where 조건에 해당 컬럼에 대한 조건이 있어야 함
select * from author where email='hong1@naver.com'
 -- email에 인덱스 조건이 걸려 있으면 ㅈㄴ빠름

-- 만약 where 조건에서 두 컬럼으로 조회 시, 한 컬럼에만 index가 있다면?
select * from author where name='hong' and email='hong2@naver.com'
  //email에만 인덱스가 있는 경우

-- 만약 where 조건에서 두 컬럼으로 조회 시, 두 컬럼 모두 각각 index가 있다면?
 -- 이 경우 DB엔진에서 최적의 알고리즘을 실행한다
select * from author where name='hong' and email='hong2@naver.com'

-- index는 한 컬럼 뿐만 아니라 두 컬럼을 대상으로 한 개의 인덱스를 설정하는 것도 가능
  -- 이 경우 두 컬럼을 and조건으로 조회해야만 index를 사용한다

  create index on 테이블명 
  

-- 기존 테이블 삭제 후 아래 테이블로 신규 생성
create table author(id bigint, eamil varchar(255), name varchar(255))

-- index 테스트 시나리오
-- 아래 프로시저를 통해 수십만건의 데이터 insert 후에 index 생성 전후에 따라 조회성능 확인
DELIMITER //
CREATE PROCEDURE insert_authors()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE email VARCHAR(100);
    DECLARE batch_size INT DEFAULT 10000; -- 한 번에 삽입할 행 수
    DECLARE max_iterations INT DEFAULT 100; -- 총 반복 횟수 (1000000 / batch_size)
    DECLARE iteration INT DEFAULT 1;
    WHILE iteration <= max_iterations DO
        START TRANSACTION;
        WHILE i <= iteration * batch_size DO
            SET email = CONCAT('jin', i, '@naver.com');
            INSERT INTO author (email) VALUES (email);
            SET i = i + 1;
        END WHILE;
        COMMIT;
        SET iteration = iteration + 1;
        DO SLEEP(0.1); -- 각 트랜잭션 후 0.1초 지연
    END WHILE;
END //
DELIMITER ;







