#!/bin/ksh
# this file takes a model CPP.keys file and build a cpp.tex file ready to be imported in the report file
# $Id$
#-------------------------------------------------------------------------------------------------------
usage() {
   echo "  USAGE: $(basename $0 ) [-h ] [-k CPP.keys ] [-o outfile ] go"
   echo "    Purpose:"
   echo "       Take a CPP.keys file used for model compilation and "
   echo "       produce a tex file ready to paste in the report."
   echo " "
   echo "    Arguments:"
   echo "       go : any word may be used, but need at least 1 arg to go on "
   echo " "
   echo "    Options:"
   echo "       [ -h ] : this help message "
   echo "       [ -k CPP.keys ] : name of CPP.keys file \(default is CPP.keys\)"
   echo "       [ -o output file ] : name of the output file. \(default is cpp.tex \)"
   echo "  "
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

key_comment() {
      zlev=$( echo $1 | awk -F= '{print $2}')
      if [ $zlev ] ; then
        zlevel=" with $zlev  levels"
        zkey=$( echo $1 | awk -F= '{print $1}')
        key=$1
      else
        zlevel=
        zkey=$1
      fi

      zout="$(grep -w $zkey $0 | sed -e "s/$zkey//") $zlevel"
      echo $zout
              }
# ------------------------------------------------------------------------------------------------
cpp_in=CPP.keys
cpp_out=cpp.tex

if [ $# = 0 ] ; then usage ; fi

while  getopts :hk:o:  V  ; do
   case $V in
     (h) usage ;;
     (k) cpp_in=${OPTARG} ;;
     (o) cpp_out=${OPTARG} ;;
     (:)  echo ${b_n}" : -"${OPTARG}" option : missing value" 1>&2;
        exit 2;;
   esac
done

if [ ! -f $cpp_in ] ; then
   print_error "     Missing $cpp_in file !"
fi

list=$( cat $cpp_in | grep -v '^#' | sed -e 's/P_P//' -e 's/=//' -e 's/\\//')

cat << eof > $cpp_out
\begin{center}
\begin{tabular}{|l|l|}
\hline
\textbf{CPP key name} & \textbf{Action:} \\\\
\hline
eof

for key in $list ; do 
   comment=$(key_comment $key)
   echo "$key        " ' &' " $comment " '   \\'  >> $cpp_out
   echo "\hline                            " >> $cpp_out
done

cat << eof >> $cpp_out
\end{tabular}
\end{center}
eof

cat $cpp_out | sed -e 's/_/\\_/g' > ztmp ; mv ztmp $cpp_out

exit
# list of keys and their comment ( up to date with nemo_3.5 )
#   DO NOT ERASE THE NEXT LINES : they are used by this script
key_agrif                 Use AGRIF nesting technique
key_amm_12km              Define AMM_12km configuration
key_antarctic             Define ANTARCTIC zoom in ORCA2
key_arctic                Define ARCTIC zoom in ORCA2
key_asminc                Use ASsiMilation INCrements
key_atl4                  Define ATL4 configuration
key_bdy                   Use BDY open boundaries scheme
key_c1d                   Use 1D nemo
key_cice                  Use CICE as ice model
key_cfc                   Use CFC passive tracer option with TOP
key_coupled               Use nemo in COUPLED mode
key_cpl_carbon_cycle      Use nemo with CouPLed CARBON CYCLE
key_degrad                Use coarsening or superparameterization
key_diaar5                Enable DIAgnostics for AR5
key_diadct                Enable DIAgnostics for Density Class Transport
key_diaeiv                Enable DIAgnostics for Eddy Induced Velocity
key_diaharm               Enable DIAgnostics for HARMonic analysis of tides
key_diahth                Enable DIAgnostics for THermocline
key_diainstant            Ouput of instantaneous field in diawri
key_diaobs                Use OBS operator for colocalisation of model variables
key_dimgout               Use DIMG binary temporary OUTput
key_dynbbl_adv            Use Bottom Boundary Layer ADVection in the DYNamics
key_dynldf_c1d            Use 1D coef for Lateral DiFfusion on the DYNamics
key_dynldf_c2d            Use 2D coef for Lateral DiFfusion on the DYNamics
key_dynldf_c3d            Use 3D coef for Lateral DiFfusion on the DYNamics
key_dynspg_exp            Use EXPlicit computation for the Surface Pressure Gradient
key_dynspg_flt            Use FiLTered computation for the Surface Pressure Gradient
key_dynspg_ts             Use Time Splitting for the Surface Pressure Gradient
key_eel_r2                Define EEL_R2 configuration
key_eel_r5                Define EEL_R5 configuration
key_eel_r6                Define EEL_R6 configuration
key_esopa                 NEMO system team key 
key_floats                Use lagrangian FLOATS
key_gib025                Define GIB025 configuration
key_gyre                  Define GYRE configuration 
key_helsinki              Use HELSINKI scheme for s-coordinates
key_iceshelf              Use ICESHELF paramaterization
key_iomput                Use XIOS for model output
key_kppcustom             Use KPP customization (??)
key_kpplktb               Use KPP ??
key_ldfslp                Compute isopycnal SLoPes for Lateral DiFfusion
key_lim2                  Use LIM2 ice model ( default EVP rheology)
key_lim2_vp               Use LIM2 ice model with VP rheology
key_lim3                  Use LIM3 ice model
key_mpp_mpi               Use MPP with MPI parallel code
key_mpp_rep               Use MPP with reproductability
key_natl025               Define NATL025 configuration
key_natl12                Define NATL12 configuration
key_nemocice_decomp       Particular to CICE
key_netcdf4               Use NETCDF4 compression capabilities
key_nosignedzero          Use a variant of the SIGN function to have always +0
key_noslip_accurate       Use Accurate no-slip lateral condition
key_oasis3                Use coupling with OASIS3
key_oasis4                Use coupling with OASIS4
key_obc                   Use Open Boundary Conditions (radiatives)
key_offline               Use OFFLINE passive tracer code
key_orca_r025             Define ORCA025 configuration
key_orca_r05              Define ORCA05 configuration
key_orca_r1               Define ORCA1 configuration
key_orca_r12              Define ORCA12 configuration
key_orca_r2               Define ORCA2 configuration
key_orca_r4               Define ORCA4 configuration
key_periant05             Define PERIANT05 configuration
key_pisces                Use PISCES biogeophysical model with TOP
key_pomme_r025            Define POMME025 configuration
key_tide                  Use tidal forcing 
key_top                   Use TOP model for passive tracers
key_trabbl                Use TRAcer Bottom Boundary Layer
key_traldf_ano            Compute TRAcer Lateral DiFfusion on ANOmalies
key_traldf_c1d            Use 1D coef for TRAcer Lateral DiFfusion
key_traldf_c2d            Use 2D coef for TRAcer Lateral DiFfusion
key_traldf_c3d            Use 3D coef for TRAcer Lateral DiFfusion
key_traldf_eiv            Use Eddy Induced Velocity on TRAcer Lateral DiFfusion
key_trddyn                Compute TRenDs on DYNamics
key_trdmld                Compute TRenDs over the Mixed Layer Depth
key_trdtra                Compute TRenDs for  TRAcers (3D)
key_trdtrc                Compute TRenDs for passive TRaCers (3D)
key_trdvor                Compute TRenDs for the VORticity
key_vectopt_loop          vectorization option (obsolete)
key_vvl                   Use Variable Volume Layer (non linear free surface)
key_zdfcst                Use ConSTant coefficient for the vertical mixing
key_zdfddm                Use Double Diffusion Mixing coefficient for the vertical 
key_zdfgls                Use GLS closure scheme for the vertical mixing
key_zdfkpp                Use KPP closure scheme for the vertical mixing
key_zdfric                Use RIChardson number parameterization for the vertical mixing
key_zdftke                Use TKE closure scheme for the vertical mixing
key_zdftmx                Use tidal mixing parametrization for the vertical mixing
