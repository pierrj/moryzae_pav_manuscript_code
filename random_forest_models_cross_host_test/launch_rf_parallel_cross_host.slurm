#!/bin/bash
#SBATCH --job-name=launch_rf_parallel_cross_host
#SBATCH --partition=savio3_htc
#SBATCH --qos=savio_normal
#SBATCH --ntasks=1
#SBATCH --time=72:00:00
#SBATCH --mail-user=pierrj@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --output=/global/home/users/pierrj/slurm_stdout/slurm-%j.out
#SBATCH --error=/global/home/users/pierrj/slurm_stderr/slurm-%j.out
#MIT License
#
#Copyright (c) 2023 Pierre Michel Joubert
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.

jobqueue_file=jobqueue_crosshost

## rice first cross host ##

cd /global/scratch/users/pierrj/PAV_SV/PAV/re_gladieux_proteomes_fungap/random_forest/cross_host

INPUT_DF=gene_info.cross_host.rice_blast.txt
INPUT_DF2=gene_info.cross_host.wheat_blast.txt
OUTPUT_STRING=cross_host_rice_first
OUTPUT_FILE=rf_results.${OUTPUT_STRING}.txt

# parameters for random forest
MAJORITY_FRACTION=0.5
APPROACH=RF
ESTIMATORS=2000
SPLIT=2
LEAF=1
FEATURES=None
DEPTH=None
BOOTSTRAP=True

if [ -f $OUTPUT_FILE ]; then
    rm $OUTPUT_FILE
fi

if [ -f $jobqueue_file ]; then
    rm $jobqueue_file
fi

REPLICATES=100

# parallelization stuff
for i in $(seq $REPLICATES); do
    echo "/global/scratch/users/pierrj/conda_envs/random_forest/bin/python /global/home/users/pierrj/git/python/rf_perf_test_cross_host.py $INPUT_DF $MAJORITY_FRACTION $APPROACH $ESTIMATORS $SPLIT $LEAF $FEATURES $DEPTH $BOOTSTRAP $INPUT_DF2 $OUTPUT_STRING" >> $jobqueue_file
done

N_NODES=3

split --number=l/${N_NODES} --numeric-suffixes=1 $jobqueue_file ${jobqueue_file}_

if [ -f slurm_ids ]; then
    rm slurm_ids
fi

for node in $(seq -f "%02g" 1 ${N_NODES})
do
    sbatch --parsable --job-name=$node.rf --export=ALL,OUTPUT_FILE=$OUTPUT_FILE,node=$node,jobqueue_file=$jobqueue_file \
    --account=co_minium \
    /global/home/users/pierrj/git/slurm/htc4_gnu_parallel_rf.slurm >> slurm_ids
done

if [ -f slurm_ids ]; then
    # wait for all jobs to finish
    sbatch -A ac_kvklight -W --dependency=afterok:$(cat slurm_ids | head -c -1 | tr '\n' ':') /global/home/users/pierrj/git/slurm/dummy_job.slurm

    wait
fi

# average results
mv $OUTPUT_FILE ${OUTPUT_FILE}.old

/global/scratch/users/pierrj/conda_envs/random_forest/bin/python /global/home/users/pierrj/git/python/average_rf_results.py ${OUTPUT_FILE}.old $OUTPUT_FILE


## wheat first cross host ##

cd /global/scratch/users/pierrj/PAV_SV/PAV/re_gladieux_proteomes_fungap/random_forest/cross_host

INPUT_DF=gene_info.cross_host.wheat_blast.txt
INPUT_DF2=gene_info.cross_host.rice_blast.txt
OUTPUT_STRING=cross_host_wheat_first
OUTPUT_FILE=rf_results.${OUTPUT_STRING}.txt

# parameters for random forest
MAJORITY_FRACTION=0.5
APPROACH=RF
ESTIMATORS=2000
SPLIT=2
LEAF=1
FEATURES=None
DEPTH=None
BOOTSTRAP=True

if [ -f $OUTPUT_FILE ]; then
    rm $OUTPUT_FILE
fi

if [ -f $jobqueue_file ]; then
    rm $jobqueue_file
fi

REPLICATES=100

# parallelization stuff
for i in $(seq $REPLICATES); do
    echo "/global/scratch/users/pierrj/conda_envs/random_forest/bin/python /global/home/users/pierrj/git/python/rf_perf_test_cross_host.py $INPUT_DF $MAJORITY_FRACTION $APPROACH $ESTIMATORS $SPLIT $LEAF $FEATURES $DEPTH $BOOTSTRAP $INPUT_DF2 $OUTPUT_STRING" >> $jobqueue_file
done

N_NODES=3

split --number=l/${N_NODES} --numeric-suffixes=1 $jobqueue_file ${jobqueue_file}_

if [ -f slurm_ids ]; then
    rm slurm_ids
fi

for node in $(seq -f "%02g" 1 ${N_NODES})
do
    sbatch --parsable --job-name=$node.rf --export=ALL,OUTPUT_FILE=$OUTPUT_FILE,node=$node,jobqueue_file=$jobqueue_file \
    --account=co_minium \
    /global/home/users/pierrj/git/slurm/htc4_gnu_parallel_rf.slurm >> slurm_ids
done

if [ -f slurm_ids ]; then
    # wait for all jobs to finish
    sbatch -A ac_kvklight -W --dependency=afterok:$(cat slurm_ids | head -c -1 | tr '\n' ':') /global/home/users/pierrj/git/slurm/dummy_job.slurm

    wait
fi

# average results
mv $OUTPUT_FILE ${OUTPUT_FILE}.old

/global/scratch/users/pierrj/conda_envs/random_forest/bin/python /global/home/users/pierrj/git/python/average_rf_results.py ${OUTPUT_FILE}.old $OUTPUT_FILE
