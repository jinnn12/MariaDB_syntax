-- 흐름제어 : case when, if, ifnull
-- if(a,b,c) : a조건이 참이면 b 반환, else c반환
select id, if(name is null, '익명사용자', name) from author;

-- ifnull(a,b) : a가 null이면 b를 반환, null이 아니면 그대로 반환
select id, ifnull(name, '익명사용자', name) from author;

select id, 
case
  when name is null then '익명사용자' 
  when name='hong1' then '홍길동'
  else name 
end (as name)
from author;

-- 경기도에 위치한 식품창고 목록 출력하기...
SELECT WAREHOUSE_ID, WAREHOUSE_NAME, ADDRESS, FREEZER_YN(FREEZER_YN, "N") AS FREEZER_YN
FROM FOOD_WAREHOUSE WHERE ADDRESS LIKE '경기도%' ORDER BY WAREHOUSE_ID

-- 조건에 부합하는 중고거래 상태 조회하기
SELECT BOARD_ID, WRITER_ID, TITLE, PRICE,
CASE 
    WHEN STATUS='SALE' THEN '판매중'
    WHEN STATUS='RESERVED' THEN '예약중'
    WHEN STATUS='DONE' THEN '거래완료'
END AS STATUS

FROM USED_GOODS_BOARD
WHERE DATE_FORMAT(CREATED_DATE, '%Y-%m-%d')='2022-10-05'
ORDER BY BOARD_ID DESC
;

-- 12세 이하인 여자 환자 목록 출력하기
SELECT PT_NAME, PT_NO, GEND_CD, AGE, 
IF (TLNO IS NULL, 'NONE', TLNO) AS TLNO
FROM PATIENT
WHERE AGE <= 12 AND GEND_CD "W"
ORDER BY AGE DESC, PT_NAME ASC
;?????????????????






