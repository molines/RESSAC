#!/bin/ksh
# this file takes a gdep.txt file and build a gdep.tex file ready to be imported in the report file
# $Id$
#-------------------------------------------------------------------------------------------------------
usage() {
   echo "  USAGE: $(basename $0 ) [-h ] [-g gdep.txt ] [-o outfile ] go"
   echo "    Purpose:"
   echo "       Take a gdep.txt file from ocean.output and "
   echo "       produce a gdep.tex file ready to paste in the report."
   echo " "
   echo "    Arguments:"
   echo "       go : any word may be used, but need at least 1 arg to go on "
   echo " "
   echo "    Options:"
   echo "       [ -h ] : this help message "
   echo "       [ -g gdep file ] : name of gdep file \(default is gdep.txt\)"
   echo "       [ -o output file ] : name of the output file. \(default is gdep.tex \)"
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

# ------------------------------------------------------------------------------------------------
gdep_in=gdep.txt
gdep_out=gdep.tex

if [ $# = 0 ] ; then usage ; fi

while  getopts :hg:o:  V  ; do
   case $V in
     (h) usage ;;
     (g) gdep_in=${OPTARG} ;;
     (o) gdep_out=${OPTARG} ;;
     (:)  echo ${b_n}" : -"${OPTARG}" option : missing value" 1>&2;
        exit 2;;
   esac
done

if [ ! -f $gdep_in ] ; then
   print_error "     Missing $gdep_in file !"
fi
first_line=$( head -1 $gdep_in )
zline=$(echo $first_line | awk '{printf" \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} \\\\ \n" ,$1,$2,$3,$4,$5 }')

cat << eof > $gdep_out
\begin{table}
\begin{center}
\begin{tabular}{|c|c|c|c|c|}
\hline
$zline
\hline
eof
cat $gdep_in | awk '{ if ( NR >1 ) { printf" \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} & \\textbf{%s} \\\\ \n" ,$1,$2,$3,$4,$5 } }' >> $gdep_out
cat << eof >> $gdep_out
\hline
\end{tabular}
\label{gdep}
\caption{ Vertical levels and vertical metrics used in the simulation}
\end{center}
\end{table}
eof

cat $gdep_out

cp $gdep_out ../TexFiles/

