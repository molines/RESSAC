#!/bin/ksh
# This script is used to create a Working space where to work for writing a run report, based on the RESSAC help tools.
# $Id$

usage() {
      echo " USAGE : $(basename $0 ) [-h] -c confif-case  "
      echo "   Purpose:"
      echo "      Build a working space under \$RESSAC_WORKDIR for the config-case report edition"
      echo " "
      echo "   Arguments:"
      echo "       -c config-case : give the name of the config-case to qork with"
      echo " "
      echo "   Options:"
      echo "       [ -h ] : print this help message "
      echo "       [ -f ] : force creation even if the directory already exists."
      echo " "
      echo "   Remarks:"
      echo "        1. Environment variable RESSAC_ROOT must be set to a directory where the "
      echo "           RESSAC package is check out from svn server"
      echo "        2. Environment variable RESSAC_WORKDIR must be set to a directory where the "
      echo    "        workspace will be created."
      exit 0
         }

print_error() {
   echo "  ============== "
   echo "  *  E R R O R * "
   echo "  ============== "
   echo "         $@"
   echo "  ---"
   echo " "
   echo " "
   usage
              }

# replace <JOKERS> by their value
filter()      {
   file=$1
   cat $file | sed -e "s/<CONFIG_CASE>/$CONFIG_CASE/g"  \
                   -e "s/<CONFIG>/$CONFIG/g"            \
                   -e "s/<CASE>/$CASE/g" > ztmp
   mv ztmp $file
              }


# ------------------------------------------------------------------------------------------------
force=0
if [ $# = 0 ] ; then usage ; fi

while  getopts :hc:f  V  ; do
   case $V in
     (h) usage ;;
     (c) CONFIG_CASE=${OPTARG} ;;
     (f) force=1 ;;
     (:)  echo ${b_n}" : -"${OPTARG}" option : missing value" 1>&2;
        exit 2;;
     (\?) echo ${b_n}" : -"${OPTARG}" option : not supported" 1>&2;
        exit 2;;
   esac
done

if [ ! $RESSAC_ROOT ] ; then 
   print_error "You must set RESSAC_ROOT environment variable (see remarks below) !"
fi

if [ ! $RESSAC_WORKDIR ] ; then 
   print_error "You must set RESSAC_WORKDIR environment variable (see remarks below) !"
fi

REPORT_DIR=$RESSAC_WORKDIR/REPORT_${CONFIG_CASE}

if [ -d $REPORT_DIR  -a $force == 0  ] ; then
  print_error " $REPORT_DIR already exist. Use -f option if you want to overwrite\n    !!Tex file will be overwritten !! "
else
  mkdir -p $REPORT_DIR
fi

mkdir -p $REPORT_DIR/INPUT_DATA
mkdir -p $REPORT_DIR/TexFiles/Namelist
mkdir -p $REPORT_DIR/TexFiles/Figures
mkdir -p $REPORT_DIR/TexFiles/Biblio

cp $RESSAC_ROOT/TexFiles/ametsoc.bst $RESSAC_ROOT/TexFiles/*.tex  $REPORT_DIR/TexFiles
cp $RESSAC_ROOT/Report_template.tex  $REPORT_DIR/${CONFIG_CASE}_report.tex
cp $RESSAC_ROOT/Makefile.tmpl $REPORT_DIR/Makefile

# customize copied files
 cd $REPORT_DIR/
 CONFIG=${CONFIG_CASE%-*}
 CASE=${CONFIG_CASE#*-}

 filter Makefile
 filter ${CONFIG_CASE}_report.tex
 cd TexFiles
 for f in *.tex ; do
    filter $f
 done

echo "===================================="
echo "*   $REPORT_DIR has been installed *"
echo "===================================="
echo " "
echo "    You must copy intput files in $REPORT_DIR/INPUT_DATA"
echo
echo "   Input files are :"
echo "      CPP_KEYS"
echo "      namelist_oce"
echo "      namelist_ice"
echo "      includefile.ksh"
echo "      journal.txt [ optional ]"
echo "      config-case-MONITOR/*nc  [ optional ]"
echo "  ---"

    
  


