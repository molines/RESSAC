#!/bin/ksh
# this script is used to produce basic plots for the report
# should be launched from INPUT_DATA dir of a RESSAC working directory
# $Id$

IDIR_ROOT=/fsnet/data/meom/MODEL_SET
CHART=chart
COUPE=coupe

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
      echo "   dmpmask  : plot the southern ocean damping mask"
      echo "   scal     : plot the scalability curv"
      echo "   maskitf  : plot the ITF mask associated with zdf_tmx"
      echo "   iceini   : plot the ice initial condition (lead frac and thickness)."
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
pl_maskitf() {
    echo ITF region :maskitf being plotted
    itf="100 170 -20 20 "
    ztmp="$(get_data_file sn_mskitf namzdf_tmx )"
    file=$( echo $ztmp | awk '{print $1}' )
    var=$( echo $ztmp  | awk '{print $2}' )

    ln -s $IDIR/$file ./$file
    $CHART  -proj ME -hi -zoom $itf  -clrdata $file -clrvar $var -clrmet 1 -p lowwhite.pal -o ${CONFIG_CASEnoDOT}_maskitf-itf.cgm \
         -xstep 10 -ystep 10 -xgrid -ygrid -clrxypal 0.1 0.95 0.1 0.2 -noteam
    cgm2jpgeps ${CONFIG_CASEnoDOT}_maskitf-itf ; mv ${CONFIG_CASEnoDOT}_maskitf-itf.jpg ../TexFiles/Figures/
                                                 mv ${CONFIG_CASEnoDOT}_maskitf-itf.eps ../TexFiles/Figures/
    rm ztmp.sun
    echo Gibraltar region :maskitf being plotted
    gib="-10 0 35 38 "
    $CHART  -proj ME -hi -zoom $gib  -clrdata $file -clrvar $var -clrmet 1 -p lowwhite.pal -o ${CONFIG_CASEnoDOT}_maskitf-gib.cgm \
         -xstep 2 -ystep 2 -xgrid -ygrid -clrxypal 0.1 0.95 0.2 0.3 -noteam
    cgm2jpgeps ${CONFIG_CASEnoDOT}_maskitf-gib ; mv ${CONFIG_CASEnoDOT}_maskitf-gib.jpg ../TexFiles/Figures/
                                                 mv ${CONFIG_CASEnoDOT}_maskitf-gib.eps ../TexFiles/Figures/
    rm ztmp.sun
           }

# ---
pl_bfr()   {
    echo bfr_Bering being plotted
    bering="-180 -160 60 70 "
    file=$(get_includefile BFR )
    ln -s $IDIR/$file ./$file
    $CHART -hi -proj ME -clrdata $file -clrvar bfr_coef -clrmet 1 -p lowwhite.pal -o ${CONFIG_CASEnoDOT}_bfr_bering.cgm -zoom $bering \
          -xstep 5 -ystep 5 -xgrid -ygrid
    cgm2jpgeps ${CONFIG_CASEnoDOT}_bfr_bering ; mv ${CONFIG_CASEnoDOT}_bfr_bering.jpg ../TexFiles/Figures/
                                                mv ${CONFIG_CASEnoDOT}_bfr_bering.eps ../TexFiles/Figures/

    echo bfr_Torres being plotted
   torres=" 135 150 -15 -5 "
    $CHART -hi -proj ME   -clrdata $file -clrvar bfr_coef -clrmet 1 -p lowwhite.pal -o ${CONFIG_CASEnoDOT}_bfr_torres.cgm -zoom $torres \
        -xstep 5 -ystep 5 -xgrid -ygrid
    cgm2jpgeps ${CONFIG_CASEnoDOT}_bfr_torres ; mv ${CONFIG_CASEnoDOT}_bfr_torres.jpg ../TexFiles/Figures/
                                                mv ${CONFIG_CASEnoDOT}_bfr_torres.eps ../TexFiles/Figures/
           }

# ---
pl_iceini()   {
    echo  iceini ithic being plotted
    file=$(get_includefile ICEINI )
    nsdic=Init_Ice_GLORYS1V1_NSIDC_BOOTSTRAP_y1989m01_new_spval.nc
    batnsdic=ORCA025_bathy_etopo1_gebco1_smoothed_coast_corrected_mar10_time.nc
    bathy=$(get_includefile BATFILE_METER ) 
    ln -sf $IDIR/$file ./$file

    $CHART -pixel -clrdata $file -clrmet 1 -xyplot 0 1 0 1 -noteam -clrmin 0 -clrmax 4.2 -nograd -clrvar hicif \
           -o ${CONFIG_CASEnoDOT}_ithic.cgm -cntdata $bathy -cntvar Bathymetry -cntmin 1 -cntmax 10 -cntint 10 -cntilt ''
    cgm2jpgeps ${CONFIG_CASEnoDOT}_ithic ; mv ${CONFIG_CASEnoDOT}_ithic.jpg ../TexFiles/Figures/
                                           mv ${CONFIG_CASEnoDOT}_ithic.eps ../TexFiles/Figures/

    $CHART -pixel -clrdata $nsdic -clrmet 1 -xyplot 0 1 0 1 -noteam -clrmin 0 -clrmax 4.2 -nograd -clrvar hicif \
           -o Bootstrap_ithic.cgm -cntdata $batnsdic -cntvar Bathymetry -cntmin 1 -cntmax 10 -cntint 10  -cntilt ''
    cgm2jpgeps Bootstrap_ithic           ; mv Bootstrap_ithic.jpg ../TexFiles/Figures/
                                           mv Bootstrap_ithic.eps ../TexFiles/Figures/

    echo  iceini ithic being plotted
    $CHART -pixel -clrdata $file -clrmet 1 -xyplot 0 1 0 1 -noteam -clrmin 0 -clrmax 1 -nograd -clrvar frld \
           -o ${CONFIG_CASEnoDOT}_leadfr.cgm -cntdata $bathy -cntvar Bathymetry -cntmin 0.8 -cntmax 10 -cntint 10 -cntilt '' -spval 1
    cgm2jpgeps ${CONFIG_CASEnoDOT}_leadfr ; mv ${CONFIG_CASEnoDOT}_leadfr.jpg ../TexFiles/Figures/
                                            mv ${CONFIG_CASEnoDOT}_leadfr.eps ../TexFiles/Figures/

    $CHART -pixel -clrdata $nsdic -clrmet 1 -xyplot 0 1 0 1 -noteam -clrmin 0 -clrmax 1 -nograd -clrvar frld \
           -o Bootstrap_leadfr.cgm -cntdata $batnsdic -cntvar Bathymetry -cntmin 0.8 -cntmax 10 -cntint 10 -cntilt '' -spval 1
    cgm2jpgeps Bootstrap_leadfr ;           mv Bootstrap_leadfr.jpg ../TexFiles/Figures/
                                            mv Bootstrap_leadfr.eps ../TexFiles/Figures/
           }

# ---
pl_rnf()   {
    echo rnf being plotted
    ztmp="$(get_data_file sn_cnf namsbc_rnf )"
    file=$( echo $ztmp | awk '{print $1}' )
    var=$( echo $ztmp  | awk '{print $2}' )
    bathy=$(get_includefile BATFILE_METER )
    ln -sf $IDIR/$file ./$file

    $CHART -pixel -clrdata $file -clrmet 1 -xyplot 0 1 0 1 -noteam -clrmin 0 -clrmax 0.5 -nograd -clrvar $var -p lowwhite.pal \
           -o ${CONFIG_CASEnoDOT}_rnf_mask.cgm -cntdata $bathy -cntvar Bathymetry -cntmin 1 -cntmax 10 -cntint 10 -cntilt ''
    cgm2jpgeps ${CONFIG_CASEnoDOT}_rnf_mask ; mv ${CONFIG_CASEnoDOT}_rnf_mask.jpg ../TexFiles/Figures/
                                              mv ${CONFIG_CASEnoDOT}_rnf_mask.eps ../TexFiles/Figures/
           }

# ---
pl_dmpmask() {
    echo damping mask at 2000 m being plotted
    file=$(get_includefile WDMP )
    bathy=$(get_includefile BATFILE_METER ) 
    ln -s $IDIR/$file ./$file
    lev=$(ncks -HF -v deptht $file | awk -F= '{if ( $2 > 2000 ) {print $1; nextfile }  }' | sed -e 's/(/ /' -e 's/)/ /' | awk '{print $2}')
    $CHART -pixel -clrmet 1 -p lowwhite.pal -clrdata $file -clrlev $lev  -clrvar wdmp -cntdata $bathy -cntvar Bathymetry -cntmin 1 -cntmax 10 -cntint 10 \
         -title @CLR_DEPTH@m -o  ${CONFIG_CASEnoDOT}_dmpmask2000.cgm 
    cgm2jpgeps ${CONFIG_CASEnoDOT}_dmpmask2000 ; mv ${CONFIG_CASEnoDOT}_dmpmask2000.jpg ../TexFiles/Figures/
                                                 mv ${CONFIG_CASEnoDOT}_dmpmask2000.eps ../TexFiles/Figures/
    echo damping mask at 3000 m being plotted
    lev=$(ncks -HF -v deptht $file | awk -F= '{if ( $2 > 3000 ) {print $1; nextfile }  }' | sed -e 's/(/ /' -e 's/)/ /' | awk '{print $2}')
    $CHART -pixel -clrmet 1 -p lowwhite.pal -clrdata $file -clrlev $lev  -clrvar wdmp -cntdata $bathy -cntvar Bathymetry -cntmin 1 -cntmax 10 -cntint 10 \
         -title @CLR_DEPTH@m -o  ${CONFIG_CASEnoDOT}_dmpmask3000.cgm 
    cgm2jpgeps ${CONFIG_CASEnoDOT}_dmpmask3000 ; mv ${CONFIG_CASEnoDOT}_dmpmask3000.jpg ../TexFiles/Figures/
                                                 mv ${CONFIG_CASEnoDOT}_dmpmask3000.eps ../TexFiles/Figures/

    echo damping mask section at 30 W being plotted

set -x
    $COUPE -pts -30 -30 -75 10   -clrdata $file -clrvar wdmp -pmax -6000 -clrmet 1 -zstep 1000 -zgrid -spval 0 -ystep 5 -ygrid \
         -o ${CONFIG_CASEnoDOT}_dmpmask30W.cgm 

set +x
    cgm2jpgeps ${CONFIG_CASEnoDOT}_dmpmask30W ; mv ${CONFIG_CASEnoDOT}_dmpmask30W.jpg ../TexFiles/Figures/
                                                mv ${CONFIG_CASEnoDOT}_dmpmask30W.eps ../TexFiles/Figures/

             }
# ---
pl_scal()    {
      cat perf.txt | graph -Tpng -g 3 -W 0.005 -C -S 16 0.05 -m 0 -w 0.8 -r 0.12 \
       -X 'Number of cores' -Y 'Steps/mn' -L "${CONFIG_CASE}"  > ztmp.png
       convert ztmp.png  ../TexFiles/Figures/${CONFIG_CASEnoDOT}_scalability.jpg
       convert ztmp.png  ../TexFiles/Figures/${CONFIG_CASEnoDOT}_scalability.eps
             }
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
   pl_shlat ; pl_bfr ; pl_rnf ; pl_dmpmask ; pl_maskitf ; pl_iceini
else
  case $plot in 
  (shlat    ) pl_shlat     ;;
  ( bfr     ) pl_bfr       ;;
  ( rnf     ) pl_rnf       ;;
  ( dmpmask ) pl_dmpmask   ;;
  ( scal    ) pl_scal  ;;
  ( maskitf ) pl_maskitf   ;;
  ( iceini  ) pl_iceini    ;;

  ( *   ) echo " This plot \( $plot \) is not yet supported." ;;
  esac
fi
