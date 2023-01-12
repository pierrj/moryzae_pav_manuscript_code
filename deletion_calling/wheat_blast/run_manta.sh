#!/bin/bash
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
while getopts f:r:t:o:d: option
do
case "${option}"
in
f) FILE=${OPTARG};;
r) REFERENCE=${OPTARG};;
t) THREADS=${OPTARG};;
o) OUTPUT=${OPTARG};;
d) OUTDIR=${OPTARG};;
esac
done

# configure and run manta
/global/scratch/users/pierrj/manta-1.6.0.centos6_x86_64/bin/configManta.py \
    --runDir ${OUTDIR}/manta_out \
    --reference ${REFERENCE} \
    --bam ${FILE}

${OUTDIR}/manta_out/runWorkflow.py \
    --quiet \
    -m local \
    -j ${THREADS}

# unzip output
zcat ${OUTDIR}/manta_out/results/variants/candidateSV.vcf.gz > ${OUTPUT}