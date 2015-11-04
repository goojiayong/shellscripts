#!/bin/bash

path=`pwd`

function mkdircommand() {
	echo function mkdircommand......
	mkdir fast
	mkdir slow
	mkdir test
	mkdir empty
	mkdir -p dir1/dir2/dir3/dir4/dir5
	mkdir -p export1/export2/export3/export4/export5

	acfs_setsync 2 fast
	acfs_setsync 1 slow
}

function touchcommand() {
	echo function touchcommand......
	for i in `seq 0 100`
	do 
		touch file$i
	done
}

function mvcommand() {
	echo function mvcommand......
	touchcommand
	mv file* dir1/dir2/
	touch file1
	mv file1 f1
	mv f1 ./test
	mv test/f1 ./slow
#	mv ./slow/* ./fast
}

function cpcommand() {
	echo function cpcommand......
	cd  export1/export2/export3/export4/export5; touchcommand
	cd $path ;cp export1/export2/export3/export4/export5/* dir1/dir2/dir3/dir4/dir5
	cp -r  export1/export2/export3/export4/export5  ./fast
	cp -r fast/* ./slow
}

function rmcommand() {
	echo function rmcommand......
	touchcommand 
	rm -f file*
	rm -f export1/export2/export3/export4/export5/*
	
	rsync -a --delete empty dir1/dir2/dir3/dir4/dir5
}

function echocommand() {
	echo function echocommand......
	for i in `seq 0 9`
	do 
		echo "numeber$i" >> file_echo
	done
	cat file_echo
}

function ddcommand() {
	echo function ddcomand......
	dd if=/dev/zero of=./file_dd bs=1M count=1024
	dd if=./file_dd of=/dev/null  
}

function lncommand() {
	echo function lncommand......
	cd $path/fast ; echo echoln >> file_ln ; ln file_ln file_ln_link ; unlink file_ln ; ln file_ln_link file_ln ; unlink file_ln_link
	cd $path/slow ; echo echoln >> file_ln ; ln file_ln file_ln_link ; unlink file_ln ;  ln file_ln_link file_ln ; unlink file_ln_link	
}

function  tarcommand() {
	echo function tarcommand......
	cd $path/test ; touchcommand 
	cd $path ; tar zcvf tar.test.gz test/
	cp tar.test.gz $path/fast 
	cp tar.test.gz $path/slow

	echo "#################cd $path/fast ; tar zvxf tar.test.gz"
	cd $path/fast ; tar zvxf tar.test.gz

	echo "#################cd $path/slow ; tar zvxf tar.test.gz"
	cd $path/slow ; tar zvxf tar.test.gz

}

function cleanfile() {
	echo function cleanfile......
	rm -rf $path/fast/
	rm -rf $path/slow/
	rm -rf $path/empty/
	rm -rf $path/test/
	rm -rf $path/dir1/
	rm -rf $path/export1/
	
	rm -rf $path/file*
	rm -rf $path/tar*
}

function man() {
	mkdircommand
	mvcommand
	cpcommand
	echocommand
	ddcommand
	lncommand
	tarcommand
	cleanfile	
#	cd $path ; rm -rf *
}
man
