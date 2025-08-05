:: 공백 없는 시각 문자열을 저장한 TIMESTAMP 변수를 만듬
For /f "delims=." %%A in (
  'wmic os get LocalDateTime^|findstr ^^20'
) Do Set DT=%%A
Set "TIMESTAMP=%DT:~0,4%-%DT:~4,2%-%DT:~6,2%-%DT:~8,2%-%DT:~10,2%-%DT:~12,2%"

:: 디렉토리 생성 시도
if not exist "db_dump" mkdir db_dump

pushd "%~dp0.."
docker-compose exec mariadb mariadb-dump -u bn_redmine bitnami_redmine > db_dump/dump_%TIMESTAMP%.sql
popd