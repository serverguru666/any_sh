#!/bin/bash
dump_user="dump_mysql"
dump_password=""
dump_storage="/storage/mysql/daily/db"
dump_log="/storage/mysql/daily/mysql_dump.log"
if [[ ! -e $dump_storage ]]
  then
    mkdir -p ${dump_storage}
  fi

if [[ ! -e $dump_log ]]
  then
     touch ${dump_log}
  fi

echo "start backup db" $(date +%Y-%m-%d-%H.%M.%S) >> ${dump_log}
mysqldump -u${dump_user} -p${dump_password} -v --insert-ignore --skip-lock-tables --ignore-table=db.odds --single-transaction=TRUE db  | gzip > ${dump_storage}/db_$(date +%Y-%m-%d-%H.%M.%S).sql.gz 2>>${dump_log}

echo "backup views"
mysql -u${dump_user} -p${dump_password} INFORMATION_SCHEMA --skip-column-names --batch -e "select table_name from tables where table_type = 'VIEW' and table_schema = 'db'" |  xargs mysqldump -u${dump_user} -p${dump_password} db > ${dump_storage}/views_$(date +%Y-%m-%d-%H.%M.%S).sql

echo "remove old backup"
find /storage/mysql/daily/db -name "*.gz" -type f -mtime +30 -exec rm -f {} \;

echo "backup done" $(date +%Y-%m-%d-%H.%M.%S) >> ${dump_log}
