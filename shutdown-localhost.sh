!/bin/bash

SHDWTYPE="$1"
FORCE="${!#}"

SHDWFAILED="shutdown failed"
SHDWSUCCESS="shutdown success"
REBOOTSUCCESS="reboot success"
REBOOTFAILED="reboot failed"

CLI="gemcli --cp=ok  --mode=script --wignore"

function check_start_volume() {
	local __volnames=`$CLI volume info | grep -B 3 'Status: Started' | grep 'Volume Name' |awk '{print $3}' `
	volnames=`echo $__volnames | sed 's/Volume Name://g'`
	if [ "x$volnames" != "x" ]; then
#		echo $volnames
		return 1
	fi
}

function __shutdown() {
	if [ "x$FORCE" = "xforce" ]; then 
		shutdown -h now  > /dev/null
		if [ $? -ne 0 ]; then
			echo "$SHDWFAILED $ipaddr"
		fi
	else
		check_start_volume 
		if [ $? -eq  1 ]; then 
			echo "started volume : $volnames"
		else
			shutdown -h now > /dev/null
		fi
	fi
}

function __reboot() {
	if [ "x$FORCE" = "xforce" ]; then 
		shutdown -r now  > /dev/null
		if [ $? -ne 0 ]; then
			echo "$REBOOTFAILED $ipaddr"
		fi
	else
		check_start_volume 
		if [ $? -eq  1 ]; then 
			echo "started volume : $volnames"
		else
			shutdown -r now  > /dev/null
		fi
	fi
}

function userage() {
	if [ "$#" -lt 1 ]; then
		echo "usage: $0 shutdown/reboot  [force]"
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
