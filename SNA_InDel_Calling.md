**MUMMER, SNV calling**
1. Download and install mummer
```
conda create -n xgenome
conda activate xgenome
conda install mummer
```
2. Call SNV from genome assemblies
- ref_QUAST/ref/, reference genomes (postfix fna)
- Prokka/, BGISEQ-500 assemblies or HiSeq 2000 assemblies
2.1 Call SNV from BGISEQ-500 assemblies
```
mkdir SNP/bgi
plat="bgi"
# 1 alignment
for i in `ls ./ref_QUAST/ref/`; do
    nucmer --mum -p ./SNP/$plat/$i ./ref_QUAST/ref/$i/${i}.fna ./Prokka/$plat/$i/${i}.fna
    echo -e "\033[32m $i done... \033[0m"
done

# 2 filtering
for i in `ls ./ref_QUAST/ref/`; do
    delta-filter -1 -q -r ./SNP/$plat/${i}.delta > ./SNP/$plat/${i}.filter
    echo -e "\033[32m $i done... \033[0m"
done

# 3 call SNP
#show-snps -Clr align_qr.filter > align_qr.snps
for i in `ls ./ref_QUAST/ref/`; do
    show-snps -Clr ./SNP/$plat/${i}.filter > ./SNP/$plat/${i}.snps
    echo -e "\033[32m $i done... \033[0m"
done
```
2.2 Call SNV from HiSeq 2000 assemblies
```
mkdir SNP/illumina
plat="illumina"
# 1 alignment
for i in `ls ./ref_QUAST/ref/`; do
    nucmer --mum -p ./SNP/$plat/$i ./ref_QUAST/ref/$i/${i}.fna ./Prokka/$plat/$i/${i}.fna
    echo -e "\033[32m $i done... \033[0m"
done

# 2 filtering
for i in `ls ./ref_QUAST/ref/`; do
    delta-filter -1 -q -r ./SNP/$plat/${i}.delta > ./SNP/$plat/${i}.filter
    echo -e "\033[32m $i done... \033[0m"
done

# 3 call SNP
#show-snps -Clr align_qr.filter > align_qr.snps
for i in `ls ./ref_QUAST/ref/`; do
    show-snps -Clr ./SNP/$plat/${i}.filter > ./SNP/$plat/${i}.snps
    echo -e "\033[32m $i done... \033[0m"
done
```
