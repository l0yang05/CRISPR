#!/bin/bash
### working dir is root folder
### command example: bash scripts/run_crispr_count_hpc.sh @NB501311 default $PWD/bowtie_index/gRNA_Dot1l_v2 Dot1l
flowID=$1
pattern=$2
bt2ref=$3
gene=$4
scripts=/isi-dcnl/ifs/user_data/CWChen_Grp/Lu/testData_CRISPR/scripts

if [ ! -d "suncluster_logs" ]; then
  mkdir suncluster_logs
fi
if [ ! -d "crispr_count" ]; then
  mkdir crispr_count
else
  echo "crispr_count directory already exists, please remove then rerun the script"
  exit 1
fi
if [ ! -d "bowtie2_mapped" ]; then
  mkdir bowtie2_mapped
else
  echo "bowtie2_mapped directory already exists, please remove then rerun the script"
  exit 1
fi
if [ ! -d "bedfiles" ]; then
  mkdir bedfiles
else
  echo "bedfile directory already exists, please remove then rerun the script"
  exit 1
fi



batch=$(date +%Y%m%d%H%M%S)  ## record batch info by starting time eg 20180110093544
echo $batch
#touch run_stats.txt
if [ ! -f "run_stats.txt" ]; then
  echo -e sampleID"\t"rawReads"\t""Extraction%""\t""PM%""\t""oneMM%""\t""twoMM%""\t""runtime(sec)" > run_stats.txt
else
  echo "run_stats.txt file exists"
  exit 1
fi


#$fname"\t"$rawreads"\t"$extractPer"\t"$PMper"\t"$MM1per"\t"$MM2per"\t"$dur
for i in fqfiles/*.f*q
do fname=${i%.f*q}
    fname=$(basename $fname)
	  echo $fname
		qsub -q short.q -o suncluster_logs/$fname'.crispr.count.log.'$batch $scripts/suncluster_crispr_count_v4.sh $flowID $i $pattern $bt2ref $gene
done
