#!/bin/bash
#SBATCH -p fat
#SBATCH --nodes=1
#SBATCH --ntasks=30
#SBATCH --ntasks-per-node=30
#SBATCH --mem=230G
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
x=${infile}
mkdir add-${x}-mix
for i in `ls 3m-${x}/`; do
    mkdir add-${x}-mix/$i
    zcat 3m-${x}/$i/${i}.bwa.read1.fastq.gz mix_${x}/mix_${x}.bwa.read1.fastq.gz > add-${x}-mix/$i/${i}.mixmix_1.fastq
    zcat 3m-${x}/$i/${i}.bwa.read2.fastq.gz mix_${x}/mix_${x}.bwa.read2.fastq.gz > add-${x}-mix/$i/${i}.mixmix_2.fastq
    echo -e "$i add mix done..."
done
