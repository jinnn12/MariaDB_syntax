# 덤프파일 생성
mysqldump -u root -p 스키마명 > 덤프파일명
mysqldump -u root -p board > mydumpfile.sql

# 덤프파일 적용(복원)
mysql -u root -p board < 덤프파일명
mysql -u root -p board < dumpfile.sql

docker exec -it 컨테이너id mysqldump -u root -p board > mydumpfile.sql
f69ef839854b
docker exec -it f69ef839854b mysqldump -u root -p board > mydumpfile.sql

# 도커를 실행한 후
# mydumpfile.sql 을 
docker exec -it f69ef839854b mariadb-dump -u root -p board > mydumpfile.sql

# 덤프파일 생성
mysqldump -u root -p 스키마명 > 덤프파일명
mysqldump -u root -p board > mydumpfile.sql
docker exec -it 컨테이너ID mariadb-dump -u root -p board -r mydumpfile.sql

# 덤프파일 적용(복원)
mysql -u root -p 스키마명 < 덤프파일명
mysql -u root -p board < mydumpfile.sql
docker exec -i 컨테이너ID mariadb -u root -p1234 board < mydumpfile.sql

----------------------------------------------------------------------
# 덤프파일 생성
mysqldump -u root -p 스키마명 > 덤프파일명
mysqldump -u root -p board > mydumpfile.sql
docker exec -it 컨테이너ID mariadb-dump -u root -p1234 board > mydumpfile.sql

# 덤프파일 적용(복원)
mysql -u root -p 스키마명 < 덤프파일명
mysql -u root -p board < mydumpfile.sql
docker exec -i f69ef839854b mariadb -u root -p1234 board < mydumpfile.sql


