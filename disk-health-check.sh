#!/bin/bash

DISK_LIST=`fdisk -l |grep "Disk /dev/sd" | awk '{print substr($2,0,8)}'`

function disk-smart-check() {
	local disk=$1
	local disk_statu=`smartctl -H $disk | grep -e "OK" -e "PASSED"`
	if [ "x$disk_statu" = "x" ]; then
		echo "$disk: Disk state exception "
		return 1
	fi
}

function disk-smart-short-check() {
	local disk=$1
	local shortime=`smartctl -c  $disk | grep -A 1 "Short self-test routine" | grep "polling time"  | awk '{print $5}' | sed 's/)//g'`
	smartctl -t short $disk > /dev/null
	if [ $shortime ]; then 
	#	local shortime=`echo "$shortime*60"|bc`
		local shortime=`expr $shortime \* 60`
		sleep  $shortime
	fi
	local no_error=`smartctl -l error $disk | grep "No Errors Logged" | wc -l`
	if [ "x$no_error" != "x1" ]; then 
		return 1
	fi
}

function mount_readonly_disk() {
	local disk=$1
	mount -o ro,remount $disk 2> /dev/null
	if [ "$?" -ne "0" ]; then
		echo "$disk: change the disk to read-only failed"
	fi
}

function smartctl_check_on() {
	local disk=$1
	local smart_statu=`smartctl -i $disk | grep Enabled | wc -l`
	if [ "$smart_statu" -lt "1" ]; then
		smartctl -s on $disk > /dev/null
	fi
}

function main() {
	local disk_list="$1"
	for disk in  $disk_list ; do 
		smartctl_check_on $disk
		disk-smart-check $disk
		if [ "$?" -eq "1" ]; then 
			mount_readonly_disk $disk
			break
		fi
		disk-smart-short-check $disk
		if [ "$?" -eq "1" ]; then 
			mount_readonly_disk $disk
			break
		fi
		echo "$disk: disk state OK"
	done
}

main "$DISK_LIST"
