#!/bin/bash

function userage(){
	echo "usage: $0 volume-name"
	exit
}

VOLNAME=$1 

if [ $# -lt 1 ];then
	userage;
fi

function get_volume_block(){
	all_block=`gemcli --cp=ok volume status $VOLNAME detail | grep Device | awk '!a[$0]++'| awk '{print $NF}'` ;
	if [ "x$all_block" = "x" ];then
		echo "get volume block error: volume name: $VOLNAME";
		return 1;
	fi
	return 0;
}

function get_total_capacity(){
	total_capacity=0;
	block_unit="" ;
	for block in $all_block ; do
		block_capacity=`gemcli --cp=ok volume status $VOLNAME detail | grep -A 4 $block | grep "Total Disk Space" |  awk '!a[$0]++' |  awk -F ': |TB|GB' '{print $2}'`
		block_unit=`gemcli --cp=ok volume status $VOLNAME detail | grep -A 4 $block | grep "Total Disk Space" |  awk '!a[$0]++' |  awk '{print substr($NF,4,5)}'`
		if [ "x$block_unit" = "xTB" ]; then
			block_capacity=`echo "$block_capacity  1024" | awk '{printf("%g",$1*$2)}'`	
		fi

	#	block_capacity=`df | grep $block | awk '{print $2}' `
	#	total_capacity=`expr $total_capacity + $block_capacity`	
		total_capacity=`echo "$total_capacity  $block_capacity" | awk '{printf("%g",$1+$2)}'`	
	done

	if [[ "x$total_capacity" == "x" ]]; then
		echo "get volume block size capacity error"
		return 1;
	fi
	return 0;
}

function get_free_size(){
	free_size=0;
	block_unit="";
	for block in $all_block ; do
		block_free=`gemcli --cp=ok volume status $VOLNAME detail | grep -A 4 $block | grep "Disk Space Free" |  awk '!a[$0]++' |  awk -F ': |TB|GB' '{print $2}'`
		block_unit=`gemcli --cp=ok volume status $VOLNAME detail | grep -A 4 $block | grep "Disk Space Free" |  awk '!a[$0]++' |  awk '{print substr($NF,4,5)}'`
		if [ "x$block_unit" = "xTB" ]; then
			block_free=`echo "$block_free  1024" | awk '{printf("%g", $1*$2)}'`	
		fi
		
	#	free_size=`expr $free_size + $block_free`
		free_size=`echo "$free_size  $block_free" | awk '{printf("%g", $1+$2)}'`
	done

	if [[ "x$free_size" == "x" ]]; then
		echo "get volume free size error"
		return 1;
	fi
	return 0;
}

function main(){
	get_volume_block
	if [ $? != 0 ];then
		return 1;
	fi
	get_total_capacity
	if [ $? != 0 ];then
		return 1;
	fi
	
	get_free_size

	echo "volume: $VOLNAME total_capacity: $total_capacity GB free_size: $free_size GB"
}

main
