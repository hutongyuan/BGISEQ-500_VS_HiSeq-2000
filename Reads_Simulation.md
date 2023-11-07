1. Download and install dwgsim
```
conda create -n dwgsim
conda activate dwgsim
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
-z random seed
```
2. Simulate three million reads for each genome (clean reads)
```
# 00_ref, file fold, NCBI downloaded reference genomes (postfix fna)
mkdir 3m
cd 3m
for i in `ls ../00_ref`; done
    base=${i%.fna}
    mkdir 3m/$base
    dwgsim -1 100 -2 100 -r 0 -R 0 -X 0 -e 0 -E 0 -p 200 \
    -N 3000000 -P $base ../00_ref/$i 3m/$base/$base
done
```
3. Mix all genomes together as contamination source 
```
mkdir 01_index
mkdir 01_index_1
mkdir 01_index_2
mkdir 01_index_4
mkdir 01_index_7
cat 00_ref/* > 01_index/merge.fna
```
4. Simulate 3M reads including 0.5% (15k) contamination
```
cd 01_index
# simulate 3m-15k clean reads
for i in `ls ../00_ref/`; do
    base=${i%.fna}
    mkdir 3m-15k/$base
    dwgsim -1 100 -2 100 -r 0 -R 0 -X 0 -e 0 -E 0 -p 200 \
    -N 2985000 -P $base ../00_ref/$i 3m-15k/$base/$base
done
# simulate 15k contaminated reads
bash ../sc_simulate.sh -i 15 -p 200
# mix clean reads and contaminated reads
bash ../sc_merge.sh -i 15
cd ..
```
5. Simulate 3M reads including 1% (30k) contamination
```
cd 01_index_1
# simulate 3m-30k clean reads
for i in `ls ../00_ref/`; do
    base=${i%.fna}
    mkdir -p 3m-30k/$base
    dwgsim -1 100 -2 100 -r 0 -R 0 -X 0 -e 0 -E 0 \
    -N 2970000 -P $base ../00_ref/$i 3m-30k/$base/$base
done
# simulate 30k contaminated reads
bash ../sc_simulate.sh -i 30 -p 200
# mix clean reads and contaminated reads
bash ../sc_merge.sh -i 30
cd ..
```
6. Simulate 3M reads including 2% (60k) contamination
```
cd 01_index_2
# simulate 3m-60k clean reads
for i in `ls ../00_ref/`; do
    base=${i%.fna}
    mkdir -p 3m-60k/$base
    dwgsim -1 100 -2 100 -r 0 -R 0 -X 0 -e 0 -E 0 \
    -N 2940000 -P $base ../00_ref/$i 3m-60k/$base/$base
done
# simulate 60k contaminated reads
bash ../sc_simulate.sh -i 60 -p 200
# mix clean reads and contaminated reads
bash ../sc_merge.sh -i 60
cd ..
```
7. Simulate 3M reads including 4% (120k) contamination
```
cd 01_index_4
# simulate 3m-120k clean reads
for i in `ls ../00_ref/`; do
    base=${i%.fna}
    mkdir -p 3m-120k/$base
    dwgsim -1 100 -2 100 -r 0 -R 0 -X 0 -e 0 -E 0 \
    -N 2880000 -P $base ../00_ref/$i 3m-120k/$base/$base
done
# simulate 120k contaminated reads
bash ../sc_simulate.sh -i 120 -p 200
# mix clean reads and contaminated reads
bash ../sc_merge.sh -i 120
cd ..
```
8. Simulate 3M reads including 7% (210k) contamination
```
cd 01_index_7
# simulate 3m-210k clean reads
for i in `ls ../00_ref/`; do
    base=${i%.fna}
    mkdir -p 3m-210k/$base
    dwgsim -1 100 -2 100 -r 0 -R 0 -X 0 -e 0 -E 0 \
    -N 2790000 -P $base ../00_ref/$i 3m-210k/$base/$base
done
# simulate 210k contaminated reads
bash ../sc_simulate.sh -i 210 -p 200
# mix clean reads and contaminated reads
bash ../sc_merge.sh -i 210
cd ..
```




