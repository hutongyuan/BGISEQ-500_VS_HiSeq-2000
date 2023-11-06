**MUMMER & Parsnp, SNV and InDel calling**
1. Download and install softwares
```
conda create -n xgenome
conda activate xgenome
conda install mummer
conda install parsnp
```
2. Prepare
```
mkdir Variant
mkdir Variant/Mummer
mkdir Variant/Mummer/BGI
mkdir Variant/Mummer/Illumina
mkdir Variant/Parsnp
# fna/Ref, file fold for downloaded reference genomes
```
3. Use MUMMER to call variants
```
## mummer
conda activate mummer

for i in `ls ./fna/Ref/`; do
    base=${i%.fna}
    # 1 aligning
    nucmer --mum -p ./Variant/Mummer/BGI/$base \
    ./fna/Ref/${base}.fna ./fna/BGI/${base}.fna
    nucmer --mum -p ./Variant/Mummer/Illumina/$base \
    ./fna/Ref/${base}.fna ./fna/Illumina/${base}.fna
    # 2 filtering
    delta-filter -1 -q -r ./Variant/Mummer/BGI/${base}.delta \
    > ./Variant/Mummer/BGI/${base}.filter
    delta-filter -1 -q -r ./Variant/Mummer/Illumina/${base}.delta \
    > ./Variant/Mummer/Illumina/${base}.filter
    # 3 call variants
    show-snps -Clr ./Variant/Mummer/BGI/${base}.filter \
    > ./Variant/Mummer/BGI/${base}.snps
    show-snps -Clr ./Variant/Mummer/Illumina/${base}.filter \
    > ./Variant/Mummer/Illumina/${base}.snps
done
```
4. Extract information from outputs of MUMMER
```
# summary mummer
rm Mummer/BGI/*fai*
rm Mummer/Illumina/*fai*
rm ../fna/Ref/*.fai

echo -e "ID\tSNV\tInsert\tDelete" >> Mummer_BGI.txt
echo -e "ID\tSNV\tInsert\tDelete" >> Mummer_Illumina.txt
for i in `ls ../fna/Ref/`; do
    base=${i%.fna}
    SNV=`cat ./Mummer/BGI/${base}.snps | sed '1,5d' | awk -F" " '{if($2!="."&&$3!=".") print $0}' | wc -l`
    Insert=`cat ./Mummer/BGI/${base}.snps | sed '1,5d' | awk -F" " '{if($2=="."&&$3!=".") print $0}' | wc -l`
    Delete=`cat ./Mummer/BGI/${base}.snps | sed '1,5d' | awk -F" " '{if($2!="."&&$3==".") print $0}' | wc -l`
    echo -e "$base\t$SNV\t$Insert\t$Delete" >> Mummer_BGI.txt
    SNV=`cat ./Mummer/Illumina/${base}.snps | sed '1,5d' | awk -F" " '{if($2!="."&&$3!=".") print $0}' | wc -l`
    Insert=`cat ./Mummer/Illumina/${base}.snps | sed '1,5d' | awk -F" " '{if($2=="."&&$3!=".") print $0}' | wc -l`
    Delete=`cat ./Mummer/Illumina/${base}.snps | sed '1,5d' | awk -F" " '{if($2!="."&&$3==".") print $0}' | wc -l`
    echo -e "$base\t$SNV\t$Insert\t$Delete" >> Mummer_Illumina.txt
    echo -e "\033[32m $i done... \033[0m"
done
```
5. Use parsnp to call variants
```
conda activate parsnp
# to acquire harvesttools
# https://harvest.readthedocs.io/en/latest/content/harvest-tools.html
harvest_route="/ROUTE/hutongyuan/softwares/harvesttools-Linux64-v1.2"
for i in `ls ./fna/Ref/`; do
    base=${i%.fna}
    mkdir ./Variant/Parsnp/$base
    parsnp \
    -c -p 10 -n mafft \
    -r ./fna/Ref/${base}.fna \
    -d ./fna/Paired/$base/*.fna \
    -o ./Variant/Parsnp/$base/
    $harvest_route/harvesttools \
    -i ./Variant/Parsnp/$base/parsnp.ggr \
    -V ./Variant/Parsnp/$base/parsnp.vcf
done
```
6. Extract information from the outputs of Parsnp
```
rm -r Parsnp/*.fai

echo -e "ID\tSNV\tBGI\tIllumina" >> Parsnp_SNV.txt
for i in `ls ./Parsnp/`; do
    SNV=`cat ./Parsnp/$i/parsnp.vcf | sed '1,6d' | wc -l`
    BGI=`cat ./Parsnp/$i/parsnp.vcf | sed '1,6d' | awk '{if($11=="1") print $0}' | wc -l`
    Illumina=`cat ./Parsnp/$i/parsnp.vcf | sed '1,6d' | awk '{if($12=="1") print $0}' | wc -l`
    echo -e "$i\t$SNV\t$BGI\t$Illumina" >> Parsnp_SNV.txt
    echo -e "$i done..."
done
```

