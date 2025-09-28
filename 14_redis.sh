# 도커를 통한 redis 설치 : 윈도우에서는 기본 설치 안되므로 도커를 통해 설치
  # redis는 리눅스 기반 (macOS도 가능능)
docker run --name redis-container -d -p 6379:6379 redis

# redis 접속 명령어
redis-cli 
(command line interface)

# docker redis 접속
docker exec -it 컨테이너ID redis-cli

# redis 는 0 ~ 15번까지의 db로 구성(default는 0번, 0번부터 15번까지 있다.)
# db번호 선택, 이거 꼭 알아야 돼요~
  # index[1]은 고객 관리로 쓰자, 등등
select db번호 

# db내 모든 키 조회
keys *

# 가장 일반적인 String 자료 구조

# set을 통해 key:value 세팅
set user:email:1 hong1@naver.com --> user:email:1 ==> key , hong1@naver.com ==> value
set user1 hong1@naver.com
set user:email:2 hong2@naver.com
# 기존 key:value가 존재할 경우 똑같은 key에 set 할 경우 덮어쓰기가 기본이다.
set user:email:1 hong3@naver.com

# key 값이 이미 존재하면 pass, 없으면 set : nx (not exist?)
set user:email:1 hong4@naver.com nx

# 만료시간 (ttl -> time to live) 설정(초단위) : ex
set user:email:5 hong5@naver.com ex 10

# redis 실전 활용 : token 등 사용자 인증 정보 저장 -> 빠른 성능을 활용용
set user:1:access_token abcdefg1234 -> 서버에 접근할 수 있는 난숫값
set user:1:access_token abcdefg1234 ex 1800 -> 1800초 만료 시간을 가진 access token
set user:1:refresh_token abcdefgt1234

# key를 통해 value get
get user1
# 특정 key 삭제 : key 삭제하면 당연히 value도 삭제된다.
del user1 
# 현재 DB내 모든 key 값 삭제
flushdb

# redis 실전 활용 : 좋아요 기능 구현 -> redis를 사용하면 동시성 이슈 해결
set likes:posting:1 0    # redis는 기본적으로 모든 keyvalue가 문자열이다. 내부적으로는 "0"으로 저장. 숫자가 아니다!
  incr likes:posting:1 # 특정 key 값의 value를 1만큼 증가, 숫자처럼 취급을 해서 1 올리고 다시 문자열로 저장.
  decr likes:posting:1 # 특정 key 값의 value를 1만큼 감소
  # 이와 관련된 명령어가 보통 자바 라이브러리에 있다.
set views:posting:1 0

# redis 실전 활용 : 재고관리 (동시성 이슈 해결)
set stocks:product1 100
decr stocks:product1 # 좋아요 개수나 재고 개수나 똑같잖아?
incr stocks:product1

# redis 실전활용 : 캐싱 기능 구현, json형식이 거의 표준
  # 1번 회원 정보 조회 : select name, email, age from member where id=1;
  # 위 데이터의 결괏값을 spring 서버를 통해 json으로 변형하여 redis에 캐싱한다.
  # 최종적인 데이터 형식 : {"name":"hong", "email":"hong@naver.com","age":30}
  set member:info:1  "{\"name\":\"hong\", \"email\":\"hong@naver.com\",\"age\":30}" ex 1000

# list 자료 구조
# redis의 list는 deque와 같은 자료구조, 즉, double-ended queue구조
# lpush : 데이터를 list 자료 구조에 왼쪽부터 삽입
# rpush : 데이터를 list 자료 구조에 오른쪽부터 삽입
lpush hongs hong1
lpush hongs hong2
rpush hongs hong3
  # push > list자료 구조

# list 조회 : 0은 리스트의 시작인덱스를 의미, -1은 리스트의 마지막인덱스를 의미
lrange hongs 0 -1 #전체조회
lrange hongs -1 -1 #마지막 값 조회
lrange hongs 0 0 #첫번째 값 조회
lrange hongs -2 -1 #마지막 두번째부터 마지막까지
lrange hongs 0 2 #첫번째부터 세번째까지 (0번째부터 2번째까지)

# list 값 꺼내기. pop : 꺼내면서 삭제
rpop hongs
lpop hongs

# A리스트에서 rpop하여 B리스트에 lpush 하겠다
rpoplpush A리스트 B리스트

# list의 데이터 개수 조회
llen hongs (listlenght의 준말)

# ttl 적용
expire hongs 20 (20초의 만료시간이 적용됩니다.)

# ttl 조회
ttl hongs

# redis 실전 활용 : 최근 조회한 상품 목록 ?! (list 시리즈즈)
rpush user:1:recent:product apple
rpush user:1:recent:product banana
rpush user:1:recent:product orange
rpush user:1:recent:product melon
rpush user:1:recent:product mango
  # 최근 본 상품 3개 조회
  lrange user:1:recent:product -3 -1

# set자료구조의 특징징 : 중복 없음, 순서 없음.
sadd memberlist m1
sadd memberlist m2
sadd memberlist m3
# set 조회
smembers memberlist
# set 멤버 개수 조회 (cardinality : 몇 개의 종류)
scard memberlist
# 특정 멤버가 set 안에 있는지 존재여부 확인
sismember memberlist m2
 #대답은 1(긍정), 0(부정)

# redis 실전 활용 : 좋아요 구현 (set 시리즈즈)
 #1. 게시글 상세보기에 들어가면
  scard positing:likes:1
  sismember posting:likes:1 a1@naver.com
 #2. 게시글에 좋아요를 하면
  sadd posting:likes:1 a1@naver.com
 #3. 좋아요 한 사람을 클릭하면
  smembers posting:likes:1

# zset : sorted set
  # 실시간으로 데이터를 쌓아갈 때 많이 활용한다.
# zset을 활용해서 최근 시간 순으로 정렬 가능 // 091330 -> score라고 함 (여기선 시간임)
# zset도 set이므로 같은 상품을 add할 경우에 중복이 제거되고, score(시간)값만 업데이트 된다. (덮어쓰기 된다고고)
zadd user:1:recent:product 091330 mango
zadd user:1:recent:product 091410 apple #마지막에 넣은 값으로 대체되기 때문에 이놈이 사라짐
zadd user:1:recent:product 091520 banana
zadd user:1:recent:product 091630 orange
zadd user:1:recent:product 091830 apple
    # zrange user:1:recent:product 0 2 이를 할 경우, mango, banana, orange

    # apple의 값을 091410 보다 작게 하면 마지막에 입력된 값이 다시 저장되어서
    # mango , apple, banana가 출력

# zset조회 : zrange (score 기준 오름차순 조회), zrevrange (reverse range, score 기준 내림차순)
zrange user:1:recent:product 0 2 # 처음부터 3개 조회 ([0], [1], [2])
zrange user:1:recent:product -3 -1 #최근 3개 상품 조회
zrevrange user:1:recent:product 0 2 #order by를 desc로 뒤집은 것임

# withscores를 통해 score 값 같이 출력
zrevrange user:1:recent:product 0 2 withscores

# 주식 시세 저장 (상품의 실시간 시세 저장)
# 종목:삼성전자, 시세:55000원, 시간:현재시간(유닉스 타임스탬프) -> 연,월,일 시간을 초단위로 변환한 것
  ### 현재 가격만 조회, 과거 시세가 사라짐 / 과거 시세는 rdb에 history insert, 실시간 시세는 redis?###
zadd stock:price:se 1748911158 55000
zadd stock:price:sk 1748911158 180000
zadd stock:price:se 1748911159 55500
zadd stock:price:sk 1748911168 183000
# 삼성전자의 현재 시세
zrevrange stock:price:se 0 0
zrange stock:price:se -1 -1

# hashes : value가 map 형태의 자료 구조 (key:value, key:value ... 형태의 자료 구조)
set member:info:1  "{\"name\":\"hong\", \"email\":\"hong@naver.com\",\"age\":30}"
hset member:info:1 name hong email hong@naver.ccom age 30 # key:value key:value . . .

# 특정 값 조회
hget member:info:1 name # --> hong이 출력
 
# 모든 객체 값 조회 (모든 key:value값 조회)
hgetall member:info:1
# 특정 요소 값 수정
hset member:info:1 name hong2
# redis 활용 상황 : 빈번하게 변경되는 객체 값을 저장 시 효율적이다.