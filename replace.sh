#
/bin/bash

if [ "x$#" != "x3" ];then
    echo "usage $0 path Original_target  replace_target "
    exit
fi

#PWD=$(dirname $0)
function replace() {
    local file=$1
    local st="$2"
    local ta="$3"

    sed -i 's/'"$st"'/'"$ta"'/g'  $file
    
}

function find_file() {
    local path=$1
    local st="$2"
    local ta="$3"
    
    if [ -d $1 ];then 
        for i in $(find $path) ; do 
            if [ ! -d $i ];then
                replace $i "$st" "$ta"
            else
                echo "error: $i :the directory is null"
            fi
        done
    else
        replace $path "$st" "$ta"
    fi
}

find_file $1 "$2" "$3"
