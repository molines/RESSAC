#!/bin/ksh

for file in $( ls *.gif *.png ) ; do

    if [ -f $file ] ; then

       ext=$( echo $file | sed -e "s/\./ /g" | awk '{ print $NF }' )
       fileout=$( echo $file | sed -e "s/$ext/jpg/g" | sed -e "s/\./dot/" )
       convert $file $fileout 

    fi

done
