M0=/mnt/gjy/acfs

tmp=`mktemp -d`
if [ ! -d $tmp ]; then
    exit 1
fi

TEST dd if=/dev/urandom of=$tmp/small bs=1024 count=1
TEST dd if=/dev/urandom of=$tmp/big bs=1024 count=4096

cs_small=$(sha1sum $tmp/small | awk '{ print $1 }')
cs_big=$(sha1sum $tmp/big | awk '{ print $1 }')

TEST df -h
TEST stat $M0

cd $M0
TEST stat .
TEST mkdir dir1
TEST [ -d dir1 ]
TEST touch file1
TEST [ -f file1 ]

for dir in . dir1; do
    TEST cp $tmp/small $dir/small
    TEST [ -f $dir/small ]
    EXPECT "1024" stat -c "%s" $dir/small
    
    EXPECT "$cs_small" echo $(sha1sum $dir/small | awk '{ print $1 }')

    TEST cp $tmp/big $dir/big
    TEST [ -f $dir/big ]
    EXPECT "4194304" stat -c "%s" $dir/big

    EXPECT "$cs_big" echo $(sha1sum $dir/big | awk '{ print $1 }')

    TEST rm -f $dir/small
    TEST [ ! -e $dir/small ]


    TEST rm -f $dir/big
    TEST [ ! -e $dir/big ]

done

TEST rmdir dir1
TEST [ ! -e dir1 ]

TEST rm -f file1
TEST [ ! -e file1 ]

rm -rf $tmp


