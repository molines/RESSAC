#!/bin/ksh

# This script extract relevant block on the namelist for the report to be written. Uses getblock from the RUN_TOOLS
# $Id$
#------------------------------------------------------------------------------------------------------------------

usage()             {
        echo " USAGE: $(basename $0) [-h] [-s] [-l] [ -b bloc_name] [-n namelist_name]."
        echo "      Create a set of files (namxxx.txt) in NAMELIST corresponding"
        echo "      to the namelist name passed as argument (default to namelist)"
        echo "      from a predefined set of namelist block."
        echo
        echo "   Options:"
        echo "     [-h ] : print this help message"
        echo "     [-s ] : show the predefined list of namelist block to extract"
        echo "     [-l ] : list the namelist block name in input namelist"
        echo "     [-b block_name] : single extraction of block_name"
        echo "     [-n namlist_name] : name of the namelist to wirk with"
        exit 0
                    }
# ---
# Get a namelist block from its name in namelist
getblock()          {
            # if a 2nd argument is passed, it is a namelist name. Default to 'namelist'
            if [ $2 ] ; then namelist=$2 ; else namelist=namelist ; fi
            cat $namelist | awk 'BEGIN {flip=0} { \
            if ( $1 == "&"blk && flip == 0 ) { flip=1   }  \
            if ( $1 != "/"  && flip == 1   ) { print $0 }  \
            if ( $1 == "/"  && flip == 1   ) { print $0 ; flip=0 }    \
                                    }' blk=$1
                    }

# ---
# list the name of predefined namelist block
list_predefined()   {
       echo  " Namelist blocks for the ocean are "
       echo  "      " $OCE_BLK
       echo  " - - - "
       echo  " Namelist blocks for the ice are "
       echo "       " $ICE_BLK
       echo  " - - - "
       exit 0
                    }

# ---
# show the name of namelist block in namelist
blk_list()          {
     if [ -f $nam_nm ] ; then
       cat $nam_nm | grep -e "^&" | sed -e "s/&//" | awk '{print $1}'
       exit 0
     else
       echo missing namelist file named $nam_nm
       exit 1
     fi
                    }
# ====================================================================================================================
   NAM_DIR=NAMELIST
   OCE_BLK=" namrun namldf namzdf namsbc_core "
   ICE_BLK=" namicerun namiceini namicedyn namicethd namice_dmp namiceout"
   nam_nm="namelist"

   single=
   lst_blk=

   while  getopts :hslb:n: V  ; do
   case $V in
     (h) usage ;;
     (s) list_predefined ;;
     (b) blk_nm=${OPTARG} ; single=1 ;;
     (l) lst_blk=1 ;;
     (n) nam_nm=${OPTARG} ;;
     (:)  echo ${b_n}" : -"${OPTARG}" option : missing value" 1>&2;
        exit 2;;
     (\?) echo ${b_n}" : -"${OPTARG}" option : not supported" 1>&2;
        exit 2;;
   esac
   done

   if [ $lst_blk ] ; then
     blk_list
   fi

   if [ $single ] ; then 
     OCE_BLK=$blk_nm
     ICE_BLK=$blk_nm
   fi

   if [ -f $nam_nm ] ; then
     mkdir -p $NAM_DIR
     # is there the 'ice' word in namelist name ?
     echo $nam_nm | grep -qi ice
     if [ $? = 0 ] ; then 
       nam_typ=ice
     else
       nam_typ=oce
     fi
     case $nam_typ in
        (ice) 
           for blk in $ICE_BLK ; do
                getblock $blk $nam_nm  > $NAM_DIR/$blk.txt
           done ;;
        (oce)
           for blk in $OCE_BLK ; do
                getblock $blk $nam_nm   > $NAM_DIR/$blk.txt
           done ;;
     esac
   else
      echo missing namelist file named $nam_nm
      exit 1
   fi

# 


exit
&namicerun     !   Share parameters for dynamics/advection/thermo
&namiceini     !   ice initialisation
&namicedyn     !   ice dynamic
&namicethd     !   ice thermodynamic
&namice_dmp    !   damping of sea ice alone open boundaries
&namiceout     !   parameters for outputs
