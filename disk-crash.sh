#!/bin/bash

PATH=`pwd`
function __dd() {
	while true ; do 
		add if=/dev/zero of=$PATH/f1 bs=1M count=10240 
	done
}

function __basic_run() {
	while true ; do 
		./rpc-coverage.sh 
	done
}

function __tar() {
	while true ; do 
		tar jvxf linux-2.6.32-504.el6.tar.bz2 > /dev/null
	done 
}

function __make() {
	while true ; do 
		tar zvxf glusterfs*.tar.gz > /dev/null
		cd glusterfs* && ./autogen.sh && ./configure && make && make install
	done
}

function __cp() {
	while true ; do 
		mkdir $PATH/dir1 && cp -r $PATH/linuxcp -r linux-2.6.32-504.e16  $PATH/dir1 
	done
}

function __mv() {
	while true ; do
		cd $PATH && mkdir dir2 && mv dir1/*  dir2 
	done
}

function main() {
	exec __dd 
	exec __basic_run 
	exec __tar
	exec __make
	exec __cp
	exec __mv
}

main
