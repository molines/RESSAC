#!/bin/ksh

if [ $# != 2 ] ; then
   echo 'USAGE : fill_template.ksh namelist.CONFIG-CASE namelist_ice'
   exit
fi

### Ask a few questions...

echo ''
echo '-------------------------------------------------------'
echo '>> Just a few questions to prepare tex file...'
echo '>> What is the first year of the run ?'

read fyear

echo ''
echo '>> What is the last year of the run ?'

read lyear

echo ''
echo '>> What is the first year of the period for mean state plots ?'

read mfyear

echo ''
echo '>> What is the first last of the period for mean state plots ?'

read mlyear

echo ''
echo 'Please verify...'
echo 'Run starts in ' $fyear and stops in $lyear
echo 'Mean state will be shown on the' $mfyear-$mlyear 'period'
echo 'are you OK with that ? (y/n)'

good_ans=0

while [ $good_ans == 0 ]  ; do

   read answer

   if [ $answer == 'y' ] || [ $answer == 'Y' ] ; then
      echo '>> Processing tex file !' ; good_ans=1
   elif [ $answer == 'n' ] || [ $answer == 'N' ] ; then
      echo '>> Oh ! Too bad... you have to run this program again' ; good_ans=1
      exit
   else
      echo '>> sorry ?!' ; good_ans=0
   fi

done

#set -x

######################################################################################
######################################################################################
##
##                                      Fonctions 
##
######################################################################################

# from JMM RUNTOOLS :
# Get a namelist block from its name in namelist
getblock()          {
            cat $2 | awk 'BEGIN {flip=0} { \
            if ( $1 == "&"blk && flip == 0 ) { flip=1   }  \
            if ( $1 != "/"  && flip == 1   ) { print $0 }  \
            if ( $1 == "/"  && flip == 1   ) { print $0 ; flip=0 }    \
                                    }' blk=$1
                    }

chkdir() { if [ ! -d $1 ] ; then mkdir $1 ; fi ; }

getfromweb() {
               WEBROOT=http://www-meom.hmg.inpg.fr/DRAKKAR/${CONFIG}/${CONFIG}-${CASE}/ ;
               HERE=$( pwd ) ;
               cd $HERE/report.${CONFIG}-${CASE}/figs_monitor ;
               wget --user=drakkar --password=nemo00 $WEBROOT/$1 ; 
               cd $HERE ;
             }

getncfromweb() {
               WEBROOT=http://www-meom.hmg.inpg.fr/DRAKKAR/${CONFIG}/${CONFIG}-${CASE}/ ;
               HERE=$( pwd ) ;
               cd $HERE/report.${CONFIG}-${CASE}/nc_monitor ;
               wget --user=drakkar --password=nemo00 $WEBROOT/$1 ; 
               cd $HERE ;
             }

######################################################################################
######################################################################################

namelist=$1
namelist_ice=$2

CONFIG=$( echo $namelist | sed -e "s/namelist.//" -e "s/-/ /" | awk '{ print $1 }' )
CASE=$(   echo $namelist | sed -e "s/namelist.//" -e "s/-/ /" | awk '{ print $2 }' )

echo Creating report for run : $CONFIG $CASE

######################################################################################
## Create subdirectories
chkdir report.${CONFIG}-${CASE}
chkdir report.${CONFIG}-${CASE}/namelist-blocks
chkdir report.${CONFIG}-${CASE}/figs_monitor
chkdir report.${CONFIG}-${CASE}/nc_monitor
chkdir report.${CONFIG}-${CASE}/figs_perso

######################################################################################
## Copy utils

cp ./src/convert_to_jpg.ksh ./report.${CONFIG}-${CASE}/figs_monitor
cp ./src/convert_to_jpg.ksh ./report.${CONFIG}-${CASE}/figs_perso

#cp ./src/plot_drake.py ./report.${CONFIG}-${CASE}/nc_monitor
#cp ./src/plot_drake.py ./report.${CONFIG}-${CASE}/nc_monitor
#cp ./src/plot_drake.py ./report.${CONFIG}-${CASE}/nc_monitor

######################################################################################
## Create namelist blocks

# path to namelist blocks
nmb="./report.${CONFIG}-${CASE}/namelist-blocks"

getblock namzdf       $namelist > $nmb/namzdf.txt
getblock namzdf_tke   $namelist > $nmb/namzdf_tke.txt
getblock namtra_ldf   $namelist > $nmb/namtra_ldf.txt
getblock namdyn_ldf   $namelist > $nmb/namdyn_ldf.txt
getblock nambbl       $namelist > $nmb/nambbl.txt
getblock namsbc       $namelist > $nmb/namsbc.txt
getblock namsbc_core  $namelist > $nmb/namsbc_core.txt
getblock namtra_qsr   $namelist > $nmb/namtra_qsr.txt
getblock namsbc_rnf   $namelist > $nmb/namsbc_rnf.txt
getblock namsbc_ssr   $namelist > $nmb/namsbc_ssr.txt
getblock namlbc       $namelist > $nmb/namlbc.txt
getblock namicedyn    $namelist_ice > $nmb/namicedyn.txt
getblock namicethd    $namelist_ice > $nmb/namicethd.txt
getblock namiceini    $namelist_ice > $nmb/namiceini.txt

######################################################################################
## Get figures from web

## 1. Mean State T/S/SSH/PSI
getfromweb CLIM_${mfyear}-${mlyear}/GLOBAL/${CONFIG}_Tgl_0_${mfyear}-${mlyear}-${CASE}.gif
getfromweb CLIM_${mfyear}-${mlyear}/GLOBAL/${CONFIG}_Sgl_0_${mfyear}-${mlyear}-${CASE}.gif
getfromweb CLIM_${mfyear}-${mlyear}/GLOBAL/${CONFIG}_SSHGLp_0_${mfyear}-${mlyear}-${CASE}.gif
getfromweb CLIM_${mfyear}-${mlyear}/ATLN/${CONFIG}_PSI_ATLN_${mfyear}-${mlyear}-${CASE}.gif

## 2. Overturning
getfromweb CLIM_${mfyear}-${mlyear}/OVT/${CONFIG}_OVT_glo_${mfyear}-${mlyear}-${CASE}.gif
getfromweb CLIM_${mfyear}-${mlyear}/OVT/${CONFIG}_OVT_atl_${mfyear}-${mlyear}-${CASE}.gif

## 3. Differences to Levitus
getfromweb CLIM_${mfyear}-${mlyear}/GLOBAL/${CONFIG}_difTgl_k1_${mfyear}-${mlyear}-${CASE}.gif
getfromweb CLIM_${mfyear}-${mlyear}/GLOBAL/${CONFIG}_difSgl_k1_${mfyear}-${mlyear}-${CASE}.gif

if [[ "$config" == *L75 ]] ; then
   getfromweb CLIM_${mfyear}-${mlyear}/GLOBAL/${CONFIG}_difTgl_k28_${mfyear}-${mlyear}-${CASE}.gif 
   getfromweb CLIM_${mfyear}-${mlyear}/GLOBAL/${CONFIG}_difSgl_k28_${mfyear}-${mlyear}-${CASE}.gif 
   getfromweb CLIM_${mfyear}-${mlyear}/GLOBAL/${CONFIG}_difTgl_k39_${mfyear}-${mlyear}-${CASE}.gif 
   getfromweb CLIM_${mfyear}-${mlyear}/GLOBAL/${CONFIG}_difSgl_k39_${mfyear}-${mlyear}-${CASE}.gif 
else
   getfromweb CLIM_${mfyear}-${mlyear}/GLOBAL/${CONFIG}_difTgl_k12_${mfyear}-${mlyear}-${CASE}.gif 
   getfromweb CLIM_${mfyear}-${mlyear}/GLOBAL/${CONFIG}_difSgl_k12_${mfyear}-${mlyear}-${CASE}.gif 
   getfromweb CLIM_${mfyear}-${mlyear}/GLOBAL/${CONFIG}_difTgl_k19_${mfyear}-${mlyear}-${CASE}.gif 
   getfromweb CLIM_${mfyear}-${mlyear}/GLOBAL/${CONFIG}_difSgl_k19_${mfyear}-${mlyear}-${CASE}.gif 
fi

## 4. Fluxes
getfromweb CLIM_${mfyear}-${mlyear}/GLOBAL/${CONFIG}_HeatFlx_${mfyear}-${mlyear}-${CASE}.gif
getfromweb CLIM_${mfyear}-${mlyear}/GLOBAL/${CONFIG}_WaterFlx_${mfyear}-${mlyear}-${CASE}.gif

## 5. Sea-ice
getfromweb CLIM_${mfyear}-${mlyear}/ICE/${CONFIG}_N_iconc_03_${mfyear}-${mlyear}-${CASE}.gif
getfromweb CLIM_${mfyear}-${mlyear}/ICE/${CONFIG}_N_iconc_09_${mfyear}-${mlyear}-${CASE}.gif
getfromweb CLIM_${mfyear}-${mlyear}/ICE/${CONFIG}_S_iconc_03_${mfyear}-${mlyear}-${CASE}.gif
getfromweb CLIM_${mfyear}-${mlyear}/ICE/${CONFIG}_S_iconc_09_${mfyear}-${mlyear}-${CASE}.gif

## 6. Timeseries
getfromweb TIME_SERIES/${CONFIG}-${CASE}_tsmean.png
getfromweb TIME_SERIES/${CONFIG}-${CASE}_nino.png

## 7. Standard images
cp ./src/ninoboxes.jpg ./report.${CONFIG}-${CASE}/figs_monitor

#getfromweb CLIM_${mfyear}-${mlyear}/ICE/${CONFIG}_N_iconc_09_MONITOR-${CASE}-1996.eps  #PB :extract
#getfromweb CLIM_${mfyear}-${mlyear}/ICE/${CONFIG}_N_iconc_09_MONITOR-${CASE}-2007.eps  #PB :extract

######################################################################################
## Get nc from web to replot some part of monitoring

getncfromweb DATA/${CONFIG}-${CASE}_MOC.nc           # ${CONFIG}-${CASE}_1y_MOC.nc
getncfromweb DATA/${CONFIG}-${CASE}_TRANSPORTS.nc    # ${CONFIG}-${CASE}_1y_TRANSPORTS.nc
getncfromweb DATA/${CONFIG}-${CASE}_ICEMONTH.nc      # ${CONFIG}-${CASE}_1m_ICEMONTH.nc

######################################################################################
## Do several plots with python

# cd report.${CONFIG}-${CASE}/nc_monitor
# python truc.py

######################################################################################
## Convert images to jpeg

# report.${CONFIG}-${CASE}/figs_monitor
# ./convert_to_jpg.ksh


######################################################################################
## Create a report from template if it does not exists

if [ ! -f ./report.${CONFIG}-${CASE}/Report_${CONFIG}-${CASE}.tex ] ; then

    cat ./src/template.tex | sed -e "s/<CONFIG>/$CONFIG/g" -e "s/<CASE>/$CASE/g" \
                         -e "s/<FYEAR>/$fyear/g" -e "s/<LYEAR>/$lyear/g" \
                         -e "s/<MFYEAR>/$mfyear/g" -e "s/<MLYEAR>/$mlyear/g" \
                         > ./report.${CONFIG}-${CASE}/Report_${CONFIG}-${CASE}.tex

fi
