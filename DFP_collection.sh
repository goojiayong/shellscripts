#!/bin/bash

#Obtain Mainboard Serial

MainboardSerial=`dmidecode | grep -A10 "Base Board Information" | grep "Serial Number" | awk 'BEGIN{FS=":"}{print $2}' | tr [A-Z] [a-z]` 2>/dev/null 
echo $MainboardSerial

#Obtain MAC Address

#EthAddr=`ifconfig -a | grep eth | grep HWaddr | awk 'BEGIN{FS=" "}{print $5}' | sed 's/:/-/g' | sort | tr [A-Z] [a-z]` 2>/dev/null
EthAddr=`ip link | grep ether | awk '{print $2}'`
echo "$EthAddr" 

#Obtain Number of CPU

if [ -f "/proc/cpuinfo" ]
then
   CPUNum=`cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l` 2>/dev/null
   echo $CPUNum
else
   echo "the /proc/cpuinfo file does not exist!"
   exit 1
fi

echo "<SSDFP><MainboardSerial>$MainboardSerial</MainboardSerial><EthAddr>$EthAddr</EthAddr><CPUNum>$CPUNum</CPUNum></SSDFP>" | sed 's/ //g' >  /usr/local/etc/gemfs/DFP.xml
cat /usr/local/etc/gemfs//DFP.xml

exit 0
