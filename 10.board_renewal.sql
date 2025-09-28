-- 여러 사용자가 1개의 글을 수정 author와 post가 n:m관계
-- author 테이블
create table author(
  id bigint author_increment primary key
  email varchar(255) not null unique,
  name varchar(255)
)

create table post(
  id bigint auto_increment primary key,
  title varchar(255) not null,
  contents varchar(3000)


)

-- n:m관계를 풀기 위한 junction table
create table post_author (
  id bigint auto_increment primary key,
  author_id bigint not null,
  post_id bigint not null,
  foreign key(author_id) references author(id),
  foreign key(post_id) references post(id)
)

-- 1:1관계 : author_address
-- 테이블의 제약조건으로서 1:1관계를 보장할 때는 unique
create table author_address (
  id bigint author_increment primary key,
  country varchar(255),
  city varchar(255),
  street varchar(255),
  author_id bigint not null unique,
  foreign key(author_id) references author(id)

)

-- 데이터 삽입
insert into author(email, name) values ('hong1@naver.com', 'hong1');
insert into author_address(country, city, author_id) values ('korea', 'seoul', 1);
insert into author(email, name) values ('hong2@naver.com', 'hong2');
insert into author_address(country, city, author_id) values ('japan', 'dokyo', 2);
insert into author(email, name) values ('hong3@naver.com', 'hong3');
insert into author_address(country, city, author_id) values ('korea', 'ggl', 3);
insert into author(email, name) values ('hong4@naver.com', 'hong4');
insert into author_address(country, city, author_id) values ('korea', 'qql', 4);

insert into author_address(country, city, author_id) values ('korea', 'seoul', 1)








-- 사용자 테이블 생성
create table author
(author_id bigint auto_increment, email varchar(50) not null,
name varchar(100), password varchar(255) not null, primary key(author_id));

create table author
(id bigint auto_increment, email varchar(50) not null,
name varchar(100), password varchar(255) not null, primary key(id));
          

-- 주소 테이블 생성
create table address
(ad_id bigint auto_increment, 
country varchar(255) not null,
city varchar(255) not null, 
street varchar(255) not null,
author_id bigint not null, primary key(ad_id), foreign key(author_id) references author(author_id));

create table address
(id bigint auto_increment, country varchar(255) not null,
 city varchar(255) not null, street varchar(255) not null,
 author_id bigint not null, primary key(id), foreign key(author_id) references author(id));

-- post 테이블 생성
create table post
(post_id bigint auto_increment, title varchar(255) not null, 
contents varchar(1000), primary key(post_id));

create table post
(id bigint auto_increment, title varchar(255) not null, 
contents varchar(1000), primary key(id));


-- 연결 테이블 생성
create table author_post
(ap_id bigint auto_increment, author_id bigint not null, post_id bigint not null, 
primary key(ap_id),
foreign key(author_id) references author(author_id), 
foreign key(post_id) references post(post_id));

create table author_post
(id bigint auto_increment, author_id bigint not null, post_id bigint not null, 
primary key(id),
foreign key(author_id) references author(id), 
foreign key(post_id) references post(id));


-- 복합키를 이용한 연결테이블 생성
create table author_post2
(author_id bigint not null, post_id bigint not null, 
primary key(author_id, post_id),
foreign key(author_id) references author(author_id), 
foreign key(post_id) references post(post_id));
---> 인덱스 활용에 관한 것인데... author id, post id 에 인덱스를 걸어주고, 나중 쿼리에서 and를 할 때 index를 사용할 수 있다는 이점이 있다.
---> author id 에서는 인덱스 활용 가능, post id에서는 인덱스 활용 못함 -> post id에 foreign을 걸어주면서 index 활용 가능해짐! 그럼 author id, post id 인덱스 활용 다 오케이이


-- 회원가입 및 주소생성
DELIMITER //
create procedure insert_author(in emailInput varchar(255), in nameInput varchar(255), in passwordInput varchar(255),in countryInput varchar(255), in cityInput varchar(255), in streetInput varchar(255))
begin
    declare exit handler for SQLEXCEPTION
    begin
        rollback;
    end;
    start transaction;
    insert into author(email, name, password) values (emailInput, nameInput, passwordInput);
    insert into address(author_id, country, city, street) values((select id from author order by id desc limit 1) , countryInput, cityInput, streetInput);
    commit;
end //
DELIMITER ;
--- 대체 왜 응? 자동으로 업데이트가 안 되는 거지???? 프로시저를 써서 직접 값을 넣는 거랑 내가 insert문 써서 넣는거랑 같은 건데 프로시저 사용하면 author_post에 값이 올라가고,
--- 내가 author, post, address에 insert 하면 author_post에 값이 안 올라감; 
  ---> 아마 변수에 오타가 있을 가능성이 높으며, 내가 직접 insert를 했다고 하더라도 author_post에 insert value를 하지 않으면 값의 변화는 일어나지 않음
  ---> foreign key는 그저 내가 잘못된 값을 넣었을 때를 방지해주기 위함이다.
  ---> 프로시저를 사용했을 땐 왜 자동이냐? 그건 진짜 자동으로 넣기 위한 일종의 함수코드인 것이다...
  ---> 결국 이 문제의 핵심은 내 변수의 오타, fk를 걸었을 때 자동으로 업데이트가 될 것이라는 착각 때문에 일어난 일이다...

DELIMITER //
create procedure insert_author(in emailInput varchar(255), in nameInput varchar(255), in passwordInput varchar(255),in countryInput varchar(255), in cityInput varchar(255), in streetInput varchar(255))
begin
    declare exit handler for SQLEXCEPTION
    begin
        rollback;
    end;
    start transaction;
    insert into author(email, name, password) values (emailInput, nameInput, passwordInput);
    insert into address(author_id, country, city, street) values((select id from author order by id desc limit 1) , countryInput, cityInput, streetInput);
    commit;
end //
DELIMITER ;



-- 회원가입 및 주소생성
DELIMITER //
create procedure insert_post(in titleInput varchar(255), in contentInput varchar(255), in passwordInput varchar(255),in countryInput varchar(255), in cityInput varchar(255), in streetInput varchar(255))
begin
    declare exit handler for SQLEXCEPTION
    begin
        rollback;
    end;
    start transaction;
    insert into author(email, name, password) values (emailInput, nameInput, passwordInput);
    insert into address(author_id, country, city, street) values((select id from author order by id desc limit 1) , countryInput, cityInput, streetInput);
    commit;
end //
DELIMITER ;




-- 글쓰기
DELIMITER //
create procedure insert_post(in titleInput varchar(255), in contentsInput varchar(255), in emailInput varchar(255))
begin
    declare exit handler for SQLEXCEPTION
    begin
        rollback;
    end;
    start transaction;
    insert into post(title, contents) values (titleInput, contentsInput);
    insert author_post(author_id, post_id) values((select id from author where email=emailInput), (select id from post order by id desc limit 1));
    commit;
end //
DELIMITER ;



-- 글편집하기
DELIMITER //
create procedure edit_post(in titleInput varchar(255), in contentsInput varchar(255), in emailInput varchar(255), in idInput bigint)
begin
    declare exit handler for SQLEXCEPTION
    begin
        rollback;
    end;
    start transaction;
    update post set title=titleInput, contents=contentsInput where id=idInput;
    insert author_post(author_id, post_id) values((select id from author where email=emailInput), idInput);
    commit;
end //
DELIMITER ;

-- JOIN하여 데이터 조회
select p.title as '제목', p.contents as '내용', a.name as '이름' from post p inner join author_post ap on p.id=ap.post_id
inner join author a on a.id=ap.author_id;
