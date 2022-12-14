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
from Bio import SeqIO
import sys
import os
import shutil
import csv

seq_dir = sys.argv[1]
out_dir = sys.argv[2]
lineage_info_file = sys.argv[3]
output_accessions = sys.argv[4]

# read in lineage info file to add lineage info to protein names (only needed for rice blast)
lineage_info = {}
with open(lineage_info_file, newline = '') as file:
    file_reader = csv.reader(file, delimiter = '\t')
    for row in file_reader:
        if row[0] == 'WD-3-1_1':
            lineage_info['WD-3-1'] = row[2]+'_'+row[3]
        else:
            lineage_info[row[0]] = row[2]+'_'+row[3]

seq_list = os.listdir(seq_dir)

if os.path.isdir(out_dir):
    shutil.rmtree(out_dir)
os.mkdir(out_dir)

accessions = []

## process and filter fasta entries
for seq in seq_list:
    print(seq)
    ## process accession names to add them to the protein names
    accession = 0
    if 'GCA' in seq:
        if seq == 'GCA_000002495.2_MG8_fungap_out_prot.faa':
            accession = '70-15'
        elif seq == 'GCA_004355905.1_PgNI_fungap_out_prot.faa':
            accession = 'NI907'
        elif seq == 'GCA_002368485.1_ASM236848v1_fungap_out_prot.faa':
            accession = 'GY11'
        elif seq == 'GCA_002368525.1_unmasked_fungap_out_prot.faa':
            accession = 'GCA002368525.1_unmasked'
        else:
            accession = seq.split('_')[0] + seq.split('_')[1]
    elif seq == 'DS0505_fungap_out_prot.faa':
        accession = 'DS0505'
    elif seq == 'FJ2003_masked_ncbi_fungap_out_prot.faa':
        accession = 'FJ2003_masked_ncbi'
    elif seq == 'FJ2003_unmasked_ncbi_fungap_out_prot.faa' :
        accession = 'FJ2003_unmasked_ncbi'
    elif seq == "guy11_fungap_out_12_28_20_prot.faa":
        accession = "GUY11"
    else:
        isolate = seq.split('_')[0]
        lineage = lineage_info[isolate]
        accession = seq.split('_')[0] + '_' + lineage
    if not accession:
        print('couldnt process accession')
    print(accession)
    accessions.append(accession)
    out_file = out_dir + '/' + accession + '_fungap_out_prot_filtered.faa'
    seq_path = seq_dir + '/' + seq
    record_list = list(SeqIO.parse(seq_path, 'fasta'))
    with open(out_file, 'w') as corrected:
        for i in range(len(record_list)):
            record = record_list[i]
            record.id = 'gene_' + str(i) + '_' + accession ## rename records to have genome name in them
            record.description = ''
            if '*' in record.seq:
                if record.seq[-1] == '*': ## remove stop codon from end of sequences
                    record.seq = record.seq[:-1]
                    SeqIO.write(record, corrected, 'fasta')
            else:
                SeqIO.write(record, corrected, 'fasta')

## output file with all chosen accession names
with open(output_accessions, 'w', newline = '') as output_csv:
    w = csv.writer(output_csv, delimiter = '\t')
    for row in accessions:
        w.writerow([row])