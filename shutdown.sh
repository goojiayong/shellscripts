#!/bin/bash

IP_LIST="$1" 
SHDWTYPE="$2"
FORCE="${!#}"

IPERROR="this IP address is incorrect"

NETERROR="connect error"

SHDWFAILED="shutdown failed"
SHDWSUCCESS="shutdown success"
REBOOTSUCCESS="reboot success"
REBOOTFAILED="reboot failed"

CLI="gemcli --cp=ok  --mode=script --wignore"

HOSTSPATH="/etc/hosts"

function check_start_volume() {
	local ipaddr=$1
	local __volnames=`ssh $ipaddr "$CLI volume info | grep -B 3 'Status: Started' | grep 'Volume Name' |awk '{print $3}' "`
	volnames=`echo $__volnames | sed 's/Volume Name://g'`
	if [ "x$volnames" != "x" ]; then
#		echo $volnames
		return 1
	fi
}

function check_ipaddr() {
	local ipaddr=$1
	
	echo $ipaddr | grep "^[0-9]\{1,3\}\.\([0-9]\{1,3\}\.\)\{2\}[0-9]\{1,3\}$" > /dev/null
	if [ $? -ne 0 ]; then
		local ipaddr=`grep $ipaddr  $HOSTSPATH | head -n 1 | awk '{print $1}'`
		echo $ipaddr | grep "^[0-9]\{1,3\}\.\([0-9]\{1,3\}\.\)\{2\}[0-9]\{1,3\}$" > /dev/null
		if [ $? -ne 0 ]; then
	#	echo $IPERROR
			return 1
		fi
	fi 

	local a=`echo $ipaddr | awk -F . '{print $1}'`
	local b=`echo $ipaddr | awk -F . '{print $2}'`
	local c=`echo $ipaddr | awk -F . '{print $3}'`
	local d=`echo $ipaddr | awk -F . '{print $4}'`

	for num in $a $b $c $d ; do 
		if [ $num -gt 255 ] || [ $num -lt 0 ]; then 
#			echo $IPERROR
			return 1
		fi
	done
}

function check_connect() {
	local ipaddr=$1
	ping $ipaddr -c 3 > /dev/null
	if [ "$?" -ne 0 ]; then 
#		echo "$ipaddr $NETERROR"
		return 1
		
	fi
}

function __shutdown() {
	for ipaddr in $IP_LIST; do 
		check_ipaddr $ipaddr
		if [ $? -ne 0 ]; then
			echo "$IPERROR $ipaddr"
			continue
		fi
		
		check_connect $ipaddr
		if [ $? -ne 0 ]; then
			echo "$NETERROR $ipaddr"
			continue
		fi

		if [ "x$FORCE" = "xforce" ]; then 
			ssh $ipaddr "shutdown -h now"  > /dev/null
			if [ $? -ne 0 ]; then
				echo "$SHDWFAILED $ipaddr"
			fi
		else
			check_start_volume $ipaddr
			if [ $? -eq  1 ]; then 
				echo "$ipaddr started volume : $volnames"
				continue

			else
				ssh $ipaddr "shutdown -h now" > /dev/null
#				if [ $? -ne 0 ]; then
#				echo "$SHDWFAILED $ipaddr"
#				fi
			fi
		fi
#		echo "$SHDWSUCCESS $ipaddr"
	done
}

function __reboot() {
	for ipaddr in $IP_LIST; do 
		check_ipaddr $ipaddr
		if [ $? -ne 0 ]; then
			echo "$IPERROR $ipaddr"
			continue
		fi
		
		check_connect $ipaddr
		if [ $? -ne 0 ]; then
			echo "$NETERROR $ipaddr"
			continue
		fi

		if [ "x$FORCE" = "xforce" ]; then 
			ssh $ipaddr "shutdown -r now"  > /dev/null
			if [ $? -ne 0 ]; then
				echo "$REBOOTFAILED $ipaddr"
			fi
		else
			check_start_volume $ipaddr
			if [ $? -eq  1 ]; then 
				echo "$ipaddr started volume : $volnames"
				continue
			else
				ssh $ipaddr "shutdown -r now"  > /dev/null
#				if [ $? -ne 0 ]; then
#				echo "$REBOOTFAILED $ipaddr"
#				fi
			fi
		fi
#		echo "$REBOOTSUCCESS $ipaddr"
	done
}

function userage() {
	if [ "$#" -lt 2 ]; then
		echo "usage: $0 ipaddr/hostname  shutdown/reboot  [force]"
		exit
	fi
}

function main() {
if [ "x$1" = "xshutdown" ]; then
	__shutdown
elif [ "x$1" = "xreboot" ]; then
	__reboot
else
	echo "argument error: $1 is not shutdown or reboot"
fi

}

userage $@

main $SHDWTYPE
