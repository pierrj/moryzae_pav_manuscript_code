#!/bin/bash
#SBATCH --job-name=repeatmasker_wheat_blast
#SBATCH --partition=savio2
#SBATCH --qos=savio_normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=72:00:00
#SBATCH --mail-user=pierrj@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --output=/global/home/users/pierrj/slurm_stdout/slurm-%j.out
#SBATCH --error=/global/home/users/pierrj/slurm_stderr/slurm-%j.out

PROJECT_DIR=/global/scratch/users/pierrj/PAV_SV/PAV/wheat_blast_all/

if [ ! -d "$PROJECT_DIR/repeatmasked" ] 
then
    mkdir $PROJECT_DIR/repeatmasked
fi

cd $PROJECT_DIR/repeatmasked

RM_LIB=/global/scratch/users/pierrj/PAV_SV/PAV/te_annotations_anne/anne_repbase_te_lib_fixed
GENOMES_PATH=/global/scratch/users/pierrj/fungap_runs/wheat_blast/genomes_to_annotate
MAPFILE=/global/scratch/users/pierrj/fungap_runs/wheat_blast/wheat_blast_busco_greater_than_90

module load repeatmasker/4.1.1

while read genome; do
    RepeatMasker -cutoff 250 -gff -nolow -no_is -norna -pa ${SLURM_NTASKS} -lib ${RM_LIB} -dir . ${GENOMES_PATH}/${genome}_genomic.fna
done < ${MAPFILE}

while read genome; do
    awk '{print $11}' ${genome}_genomic.fna.out | paste ${genome}_genomic.fna.out.gff - > ${genome}.w_class.gff
done < ${MAPFILE}