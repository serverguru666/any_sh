#! /bin/bash
TWOWEEKSAGO=$(date -d 'now - 14 days' '+%Y-%m-%d')
CURRENT=$(date +'%Y-%m-%d')

#### List of running services containing 'enter the rule here' in name field. Result print in "%Y-%M-%D  SERVICE_ID" format, separated by space.
docker service inspect --format='{{.UpdatedAt}} {{.ID}}' $(docker service ls | grep 'enter the rule here' | awk '{print $1}') | awk '{print $1 " " $5}' | sort -k1 > tmp_result
touch out_tmp_result
awk -v TWOWEEKSAGO="$TWOWEEKSAGO" '$1 <= TWOWEEKSAGO { print }' <tmp_result >out_tmp_result && mv out_tmp_result tmp_result
sleep 5s
docker service rm $(cat tmp_result | awk '{print $2}')
rm tmp_result
