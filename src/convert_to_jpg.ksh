#!/bin/ksh

# convert all gif or png files into jpg files
for file in  *.gif *.png  ; do

    if [ -f $file ] ; then
       ext=${file##*.}
       fileout=${file%.$ext}.jpg
       convert $file $fileout 
    fi

done
