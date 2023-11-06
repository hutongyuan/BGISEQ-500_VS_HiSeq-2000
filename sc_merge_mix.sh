#!/bin/bash

helpdoc(){
    cat <<EOF
Description:

    This is a help document
    - Plot circos

Usage:

    $0 -i <input file> -o <output file>

Option:

    -i    this is a input file/fold
    -o    this is a output file/fold
EOF
}

while getopts ":i:o:" opt
do
    case $opt in
        i)
        infile=`echo $OPTARG`
        ;;
        o)
        outfile=`echo $OPTARG`
        ;;
        ?)
        echo "unknown parameter"
        exit 1;;
    esac
done

if [ $# = 0 ]
then
    helpdoc
    exit 1
fi

# code
mkdir add-${infile}k-mix
for i in `ls 3m-${infile}k/`; do
    mkdir add-${infile}k-mix/$i
    zcat 3m-${infile}k/$i/${i}.bwa.read1.fastq.gz mix_${infile}k/mix_${infile}k.bwa.read1.fastq.gz > add-${infile}k-mix/$i/${i}.mixmix_1.fastq
    zcat 3m-${infile}k/$i/${i}.bwa.read2.fastq.gz mix_${infile}k/mix_${infile}k.bwa.read2.fastq.gz > add-${infile}k-mix/$i/${i}.mixmix_2.fastq
    echo -e "$i done..."
done
