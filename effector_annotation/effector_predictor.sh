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
while getopts i:o: option
do
case "${option}"
in
i) INPUT_FILE=${OPTARG};;
o) OUTPUT_NAME=${OPTARG};;
esac
done

## get TRUE/FALSE table for each tm, signalp, effectorp

## list of proteins with no tm
cat ${INPUT_FILE} | /global/scratch/users/pierrj/tmhmm-2.0c/bin/tmhmm > ${OUTPUT_NAME}.tmhmmout
awk -v OFS='\t' '{if ($3 == "Number" && $7 == 0){print $2, "FALSE"} else if ($3 == "Number" && $7 > 0) {print $2, "TRUE"}}' ${OUTPUT_NAME}.tmhmmout > ${OUTPUT_NAME}.tmhmm.table

## list of proteins with sp
/global/scratch/users/pierrj/signalp-4.1/signalp -t euk -u 0.34 -U 0.34 -f short ${INPUT_FILE} > ${OUTPUT_NAME}.signalpout.short
awk -v OFS='\t' '{ if ($10 == "Y") {print $1, "TRUE"} else if ($10 == "N") {print $1, "FALSE"} }' ${OUTPUT_NAME}.signalpout.short | sort -k1,1 > ${OUTPUT_NAME}.signalp.table

## subset to get both, in order to get input for effectorp
awk '{if ($7 == 0){print $2}} ' ${OUTPUT_NAME}.tmhmmout > ${OUTPUT_NAME}.notm.names
seqtk subseq ${INPUT_FILE} ${OUTPUT_NAME}.notm.names > ${OUTPUT_NAME}.notm.faa
/global/scratch/users/pierrj/signalp-4.1/signalp -t euk -u 0.34 -U 0.34 -f short ${OUTPUT_NAME}.notm.faa > ${OUTPUT_NAME}.signalpout.short
awk '{ if ($10 == "Y") {print $1} }' ${OUTPUT_NAME}.signalpout.short > ${OUTPUT_NAME}.notm.sp.names
seqtk subseq ${OUTPUT_NAME}.notm.faa ${OUTPUT_NAME}.notm.sp.names > ${OUTPUT_NAME}.notm.sp.faa

## run effectorp
python /global/scratch/users/pierrj/EffectorP-3.0/EffectorP.py -i ${OUTPUT_NAME}.notm.sp.faa > ${OUTPUT_NAME}.effectorpout
awk '{ if ($(NF) == "effector") {print $1}}' ${OUTPUT_NAME}.effectorpout > ${OUTPUT_NAME}.predicted_effectors

awk -v OFS='\t' '{ if ($(NF) == "effector") {print $1, "TRUE"} else if ($(NF) == "Non-effector") {print $1, "FALSE"}}' ${OUTPUT_NAME}.effectorpout > ${OUTPUT_NAME}.effectorp.table