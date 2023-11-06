#!/bin/bash

helpdoc(){
    cat <<EOF
Description:

    This is a help document
    - Plot circos

Usage:

    $0 -i <input file> -o <output file> -p <other parameter>

Option:

    -i    this is a input file/fold
    -o    this is a output file/fold
    -p    this is a parameter
EOF
}

while getopts ":i:o:p:" opt
do
    case $opt in
        i)
        infile=`echo $OPTARG`
        ;;
        o)
        outfile=`echo $OPTARG`
        ;;
        p)
        otherp=`echo $OPTARG`
        ;;
        ?)
        echo "unkown parameter"
        exit 1;;
    esac
done

if [ $# = 0 ]
then
    helpdoc
    exit 1
fi

# code

source /route/miniconda3/etc/profile.d/conda.sh
conda activate base

infile2=${infile}000
## simulate reads
mkdir ecoli_${infile}k_${outfile}
dwgsim -1 100 -2 100 -r 0 -R 0 -X 0 -e 0 -E 0 -z $otherp \
-N $infile2 -P ecoli ../01_index/ecoli.fna ecoli_${infile}k_${outfile}/ecoli_${infile}k
mkdir mix_${infile}k_${outfile}
dwgsim -1 100 -2 100 -r 0 -R 0 -X 0 -e 0 -E 0 -z $otherp \
-N $infile2 -P mix ../01_index/merge.fna mix_${infile}k_${outfile}/mix_${infile}k
