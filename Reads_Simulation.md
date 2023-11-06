1. Download and install dwgsim
```
conda install dwgsim
```
- key parameters
```
-1 length of the first read
-2 length of the second read
-r rate of mutations 
-R fraction of mutations that are indels
-X probability an indel is extended
-e per base/color/flow error rate of the first read
-E per base/color/flow error rate of the second read
-N number of read pairs
-P a read prefix to prepend to each read name
-d outer distance between the two ends for pairs [500]
```
2. Simulating three million reads for each genome (clean reads)
```
# 00_ref, fold file, NCBI downloaded reference genomes (postfix fna)
mkdir 3m
cd 3m
for i in `ls ../00_ref`; done
    base=${i%.fna}
    mkdir 3m/$base
    dwgsim -1 100 -2 100 -r 0 -R 0 -X 0 -e 0 -E 0 \
    -N 3000000 -P $base ../00_ref/$i 3m/$base/$base
done
```
3. 
```
mkdir mix_15k
dwgsim -1 100 -2 100 -r 0 -R 0 -X 0 -e 0 -E 0 \
-N 15000 -P mix merge.fna mix_15k/mix_15k
```





