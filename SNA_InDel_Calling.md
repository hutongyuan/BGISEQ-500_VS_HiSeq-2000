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
3. Extract relevant information of insertion and deletion from output
3.1 InDel in BGISEQ-500 assemblies
```
plat="bgi"

cd SNP
touch snp_indel.summary
echo -e "plat\tgenome\tsnv\tinsert\tdelete" > snp_indel.summary

for i in `ls $plat/*.snps`; do
    file=${i#${plat}/}
    base=${file%.snps}
    snp=`cat $i | sed '1,5d' | awk -F" " '{if($2!="."&&$3!=".") print $0}' | wc -l`
    insert=`cat $i | sed '1,5d' | awk -F" " '{if($2=="."&&$3!=".") print $0}' | wc -l`
    delete=`cat $i | sed '1,5d' | awk -F" " '{if($2!="."&&$3==".") print $0}' | wc -l`
    echo -e "$plat\t$base\t$snp\t$insert\t$delete" >> snp_indel.summary
    echo -e "\033[32m $i done... \033[0m"
done
```
3.2 InDel in HiSeq assemblies
```
plat="illumina"

cd SNP
touch snp_indel.summary
echo -e "plat\tgenome\tsnv\tinsert\tdelete" > snp_indel.summary

for i in `ls $plat/*.snps`; do
    file=${i#${plat}/}
    base=${file%.snps}
    snp=`cat $i | sed '1,5d' | awk -F" " '{if($2!="."&&$3!=".") print $0}' | wc -l`
    insert=`cat $i | sed '1,5d' | awk -F" " '{if($2=="."&&$3!=".") print $0}' | wc -l`
    delete=`cat $i | sed '1,5d' | awk -F" " '{if($2!="."&&$3==".") print $0}' | wc -l`
    echo -e "$plat\t$base\t$snp\t$insert\t$delete" >> snp_indel.summary
    echo -e "\033[32m $i done... \033[0m"
done
```


