#!/bin/ksh
# this script is used to produce basic plots for the report
# should be launched from INPUT_DATA dir of a RESSAC working directory

IDIR_ROOT=/fsnet/data/meom/MODEL_SET

usage() {
      echo " "
      echo "USAGE: $(basename $0)  -p plot_type | -a  [-c config-case]  [-h]  [-l] [-i IDIR]"
      echo "   Purpose:"
      echo "      This script build the basic plots used in a RESSAC report and produce"
      echo "      ready to install jpg and eps files for TexFiles/Figures of the"
      echo "      working report. This script must be launched from the INPUT_DATA dir "
      echo "      of a RESSAC report working directory."
      echo " "
      echo "   Arguments:"
      echo "      -p plot_type  : This argument is mandatory unless -a option is used."
      echo "               Indicates the type of plots to perform. Use -l option to have a"
      echo "               list of available plots."
      echo "      -a : Produce all plots "
      echo " "
      echo "   Options:"
      echo "      -h : Print this help message"
      echo "      -l : Print the list of available plots."
      echo "      -i IDIR : Give the path name of the CONFIG/CONFIG_CASE-I directory"
      echo "           Replace the default value which is $IDIR_ROOT"
      echo "      -c config-case : force a config-case name. It is normay infered from the"
      echo "           base name of the actual directory"
      echo " "
      exit $1
        }
# ---

lstplot () {
      echo " Possible argument of -p switch  are :"
      echo "   shlat    : plot the shlat 2D coefficient."
      echo "   bfr      : plot the bfr  2D mask."
      echo "   rnf      : plot the runoff mask coefficient"
      echo " ..."
      exit 0
           }
# ---

pl_shlat() {
    echo shlat
           }
# ---

pl_bfr()   {
    echo bfr
           }

# ---
pl_rnf()   {
    echo rnf
           }

# ---

# ---
here=$(pwd)
if [ $(basename $here)  != INPUT_DATA ] ; then
   echo "  === E R R O R : Should be used in INPUT_DATA directory "
   usage 1
fi

plot_all=
CONFIG_CASE=

while getopts :hc:p:i:al V ; do
  case $V in 
  ( h ) usage 0 ;;
  ( a ) plot_all=1 ;;
  ( c ) CONFIG_CASE=${OPTARG} ;;
  ( p ) plot=${OPTARG} ;;
  ( i ) IDIR_ROOT=${OPTARG} ;;
  ( l ) lstplot ;;
  (\? ) echo "  === E R R O R : unknown option : -${OPTARG}"           ; usage 1 ;;
  (: )  echo "  === E R R O R : missing argument to option -${OPTARG}" ; usage 1 ;;
  esac
done

if  [ ! $CONFIG_CASE ] ; then # infer config-case from local directory
  ztmp=$( basename $(dirname $here )) ; CONFIG_CASE=${ztmp#REPORT_}
fi
echo $CONFIG_CASE ; exit

CONFIG=${CONFIG_CASE%-*}
CASE=${CONFIG_CASE#*-}
IDIR=$IDIR_ROOT/${CONFIG}/${CONFIG_CASE}-I

if [ $plot_all ] ; then
   pl_shlat ; pl_bfr ; pl_rnf 
else
  case $plot in 
  (shlat) pl_shlat ;;
  ( bfr ) pl_bfr   ;;
  ( rnf ) pl_rnf   ;;



  ( *   ) echo " This plot \( $plot \) is not yet supported." ;;
  esac
