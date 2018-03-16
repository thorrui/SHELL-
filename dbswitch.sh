#!/bin/bash
##############################
#  双主Mysql故障切换工具类 swich hosts mysql_read_only
#  Author: rui.tong
##############################

function usage() {
        echo "Usage: $0 mysql_peer_ip"
        echo ""
        echo "mysql_peer_ip: Need to operate the MySQL IP"
        echo ""
        exit 1
}

[ $# = 0 ] && usage
[[ $1 = '-h' || $1 = '--help' ]] && usage


##args
MYSQL_PEER_IP=$1
HOSTS="/etc/hosts"
DIR=/tmp/hosts_`date +%Y%m%d`
MYSQL_PATH="/home/data/mydb/bin/mysql"

### set hosts'
function Change_hosts ()
{
 cp $HOSTS $DIR
 if [[ -z $MYSQL_PEER_IP ]] ; then
     echo "Error: Please enter a MySQL IP to operate! eg. offline"
     exit 1
 else
     sed -i -r -e "/mysql/d" -e "\$a$MYSQL_PEER_IP mysql.dci.daho.prod"  $HOSTS
     echo " This $MYSQL_PEER_IP  IS Exist .......... "
 fi
}

function mysql_db_swich ()
{
  if [[ -z $MYSQL_PEER_IP ]] ; then
     echo "Error: Please enter a MySQL IP to operate! eg. offline"
     exit 1
  else
     /home/data/mydb/bin/mysql -udaho -p1234 -h $MYSQL_PEER_IP -e"set global read_only=1;"
     echo "MySQL State action Confirmation:" `/home/data/mydb/bin/mysql  -udaho -p1234 -h $MYSQL_PEER_IP -e'show global variables like "%read_only%";'`
  fi

}

Change_hosts
mysql_db_swich
