#!/bin/ksh
# this script is used to produce basic plots for the report
# should be launched from INPUT_DATA dir of a RESSAC working directory
# $Id$

IDIR_ROOT=/fsnet/data/meom/MODEL_SET
CHART=chart

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
      echo "      -i IDIR_root : Give the path name of the CONFIG/CONFIG_CASE-I directory"
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

cgm2jpgeps()  {
    ctrans -res 1024x1024 -d sun $1.cgm > ztmp.sun
    convert -quality 100 ztmp.sun $1.jpg
    convert -quality 100 ztmp.sun $1.eps
           }
# ---

get_data_file() { 
    nam=../TexFiles/Namelist/$2
    file=$(grep $1 $nam | grep -v '^!' | awk -F\' '{print $2}' ).nc
    var=$(grep $1 $nam | grep -v '^!'  | awk -F\' '{print $4}' )
    echo $file $var
                }

get_includefile() {
    nam=./${CONFIG_CASE}_includefile.ksh
    ztmp=$( grep $1 $nam | grep -v '^#' | awk '{ print $1}' )
    echo ${ztmp#*=}
                  }

pl_shlat() {
    echo shlat being plotted
    ztmp="$(get_data_file sn_shlat2d namlbc )"
    file=$( echo $ztmp | awk '{print $1}' )
    var=$( echo $ztmp  | awk '{print $2}' )

    bathy=$(get_includefile BATFILE_METER ) 
    ln -s  $IDIR/$bathy ./$bathy
    ln -s $IDIR/$file ./$file
    $CHART  -pixel -clrdata $file -clrvar $var -clrmet 1 -p lowwhite.pal -cntdata $bathy -cntvar Bathymetry -cntmin 1 -cntmax 10 -cntint 10 \
            -cntilt ' ' -o ${CONFIG_CASEnoDOT}_shlat.cgm
    cgm2jpgeps ${CONFIG_CASEnoDOT}_shlat ; mv ${CONFIG_CASEnoDOT}_shlat.jpg ../TexFiles/Figures/
                                           mv ${CONFIG_CASEnoDOT}_shlat.eps ../TexFiles/Figures/
    rm ztmp.sun
           }
# ---

pl_bfr()   {
    echo bfr_Bering being plotted
    bering="-180 -160 60 75 "
    file=$(get_includefile BFR )
    ln -s  $IDIR/$bathy ./$bathy
    ln -s $IDIR/$file ./$file
echo  $CHART -hi -proj ME -clrdata $file -clrvar bfr_coef -clrmet 1 -p lowwhite.pal -o ${CONFIG_CASEnoDOT}_bfr_bering.cgm -zoom $bering -360
    $CHART -hi -proj ME -clrdata $file -clrvar bfr_coef -clrmet 1 -p lowwhite.pal -o ${CONFIG_CASEnoDOT}_bfr_bering.cgm -zoom $bering -360
    cgm2jpgeps ${CONFIG_CASEnoDOT}_bfr_bering ; mv ${CONFIG_CASEnoDOT}_bfr_bering.jpg ../TexFiles/Figures/
                                                mv ${CONFIG_CASEnoDOT}_bfr_bering.eps ../TexFiles/Figures/

    echo bfr_Torres being plotted
   torres=" 135 159 -15 -5 "
    $CHART -hi -proj ME   -clrdata $file -clrvar bfr_coef -clrmet 1 -p lowwhite.pal -o ${CONFIG_CASEnoDOT}_bfr_torres.cgm -zoom $torres -360
    cgm2jpgeps ${CONFIG_CASEnoDOT}_bfr_torres ; mv ${CONFIG_CASEnoDOT}_bfr_torres.jpg ../TexFiles/Figures/
                                                mv ${CONFIG_CASEnoDOT}_bfr_torres.eps ../TexFiles/Figures/
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

CONFIG=${CONFIG_CASE%-*}
CASE=${CONFIG_CASE#*-}
IDIR=$IDIR_ROOT/${CONFIG}/${CONFIG}-I
# graph in latex complains if there is more than one dot in file name ...
CONFIGnoDOT=$(echo $CONFIG | tr -d '.')
CASEnoDOT=$(echo $CASE | tr -d '.')
CONFIG_CASEnoDOT=${CONFIGnoDOT}-${CASEnoDOT}

if [ $plot_all ] ; then
   pl_shlat ; pl_bfr ; pl_rnf 
else
  case $plot in 
  (shlat) pl_shlat ;;
  ( bfr ) pl_bfr   ;;
  ( rnf ) pl_rnf   ;;



  ( *   ) echo " This plot \( $plot \) is not yet supported." ;;
  esac
fi
