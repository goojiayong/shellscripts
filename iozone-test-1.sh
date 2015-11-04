#!/bin/bash

function usage() {
	echo "usage: $0 mount-path block-size file-size thread-number"
	exit
}

if [ $# != 4 ] ;then
	usage
elif [ ! -d $1 ] ; then 
	echo "Error:Directory does not exist"
	exit
fi

PATH=$1
BLSZ=$2
FLSZ=$3
THNU=$4

function cache_clean() {
	echo 1 > /proc/sys/vm/drop_caches
}

#function file-clean() {
#	rm -f $PATH/*.ioz
#}

function iozone-test {
#    thread-nu=$1
    local namenu=$[ $1 - 1 ]
    if [ "$namenu" -lt "0" ] ;then
        echo "thread-number error"
        exit
    else
        cache_clean
iozone -w -c -e -i 0 -+n -r $BLSZ  -s $FLSZ -t $THNU -F $PATH/{0..$name-nu}.ioz
    fi
}

#BR=1
#while [[ "$BR" == "1" ]]  ; do
#while $BR
#do
#	THNU=$[ $THNU / 2 ]
#	if [ "$THNU" -le "0" ] ; then
#		BR=false
#	else
#		iozone-test THNU
#	fi
#done
iozone-test $THNU


