#!/bin/bash

if [ $# != 2 ]; then 
    echo "usage : $0  heal_brick  notbad_brick"
    exit
fi

HEAL_BRICK=$1
NOTBAD_BRICK=$2

ls $NOTBAD_BRICK -l
start_time=`date +%s`
filesizea=`ls $NOTBAD_BRICK -l | grep heal | awk '{print $5}'`
filesizeb=`ls $HEAL_BRICK -l | grep heal | awk '{print $5}'`
echo "brickafile=$filesizea"
echo "brickbfile=$filesizeb"
while true ; do
    if [[ "$filesizeb" -ge  "$filesizea" ]]; then
       end_time=`date +%s`
       break
    fi
    filesizeb=`ls $HEAL_BRICK -l | grep heal | awk '{print $5}'`
    #echo "heal-file=$filesize"
done

heal_time=`expr $end_time - $start_time`
heal_size=$filesizeb

heal_speed=`expr $heal_size / $heal_time`
heal_speed=`expr $heal_speed / 1024`

echo "heal_time=$heal_time s"
echo "heal_size=$heal_size b"
echo "heal_speed=$heal_speed KB/s"
