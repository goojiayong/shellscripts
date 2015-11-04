#!/bin/bash

path=`pwd`

function getsync() {
	acfs_getsync $path/fast
	acfs_getsync $path/slow
	acfs_getsync $path/default
}

mkdir $path/fast
mkdir $path/slow
mkdir $path/default

getsync

acfs_setsync 2 $path/fast
acfs_setsync 1 $path/slow

sleep 3

cd $path/fast; for i in `seq 0 19` ; do touch file_fa_$i ;done
cd $path/slow ;for i in `seq 0 19` ; do touch file_sl_$i ;done
cd $path/default ; for i in `seq 0 19` ; do touch file_de_$i ;done

getsync
