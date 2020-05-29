#!/bin/bash
###Нужно скачать и поставить
###https://repo.percona.com/apt/
###
percona_dump_user="percona_dump"
percona_dump_password=""
percona_dump_storage="/storage/mysql/hourly/"
percona_dump_log="/storage/mysql/mysql_hourly_dump.log"

rm -rf ${percona_dump_storage}

if [[ ! -e $percona_dump_log ]]
  then
    touch ${percona_dump_log}
  fi


echo "start hourly backup" $(date +%Y-%m-%d-%H.%M.%S) >> ${percona_dump_log}
innobackupex -u${percona_dump_user} -p${percona_dump_password} ${percona_dump_storage}

echo "applying log" $(date +%Y-%m-%d-%H.%M.%S) >> ${percona_dump_log}
innobackupex -u${percona_dump_user} -p${percona_dump_password} --apply-log ${percona_dump_storage}/$(ls ${percona_dump_storage}) 
