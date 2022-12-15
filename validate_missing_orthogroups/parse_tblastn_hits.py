import numpy as np
import csv
from itertools import filterfalse
import sys

input_file = sys.argv[1]
e_value = float(sys.argv[2])
pident = int(sys.argv[3])
query_cov = int(sys.argv[4])
hit_count = int(sys.argv[5])
genome = sys.argv[6]
og = sys.argv[7]

prelim_hits = {}

with open(input_file, newline = '') as file:
    file_reader = csv.reader(file, delimiter = '\t')
    for row in file_reader:
        if row[0] not in prelim_hits:
            prelim_hits[row[0]] = []
        prelim_hits[row[0]].append([row[1],float(row[2]),int(row[3]),int(row[4]),
                             int(row[5]),int(row[6]),int(row[7]),
                             (int(row[8])/(int(row[8])+int(row[9])))*100]) # calculate pident manually here
prelim_hits_arrays = {}

for key in prelim_hits.keys():
    prelim_hits_arrays[key] = np.array(prelim_hits[key], dtype=object)

parsed_hits = {}

for protein in prelim_hits.keys():
    prelim_hit_sorted = prelim_hits_arrays[protein][prelim_hits_arrays[protein][:, 5].argsort()]
    count = 0
    previous = 0
    for index in range(len(prelim_hit_sorted)):
        hsp = prelim_hit_sorted[index]
        if np.any(previous != 0):
            if hsp[5] - previous[6] < 3000:
                parsed_hits[protein+'_'+str(count)].append(hsp)
                previous = hsp
            elif index == len(prelim_hit_sorted)-1:
                count += 1
                parsed_hits[protein+'_'+str(count)] = []
                parsed_hits[protein+'_'+str(count)].append(hsp)
            else:
                count += 1
                parsed_hits[protein+'_'+str(count)] = []
                parsed_hits[protein+'_'+str(count)].append(hsp)
                previous = hsp
        else:
            previous = hsp
            parsed_hits[protein+'_'+str(count)] = []
            parsed_hits[protein+'_'+str(count)].append(hsp)
            
parsed_hits_arrays = {}

for key in parsed_hits.keys():
    parsed_hits_arrays[key] = np.array(parsed_hits[key], dtype=object)

protein_hits = []
valid_hits = []

for protein in parsed_hits_arrays:
    hit = parsed_hits_arrays[protein]
    hit = hit[hit[:,1] < e_value] # remove hsps below evalue
    hit = hit[hit[:,7] > pident] # remove hsps below pident
    if hit.size != 0: # check that it isn't empty
        if np.max(hit[:,0]) == np.min(hit[:,0]): # make sure all are from same scaffold
            protein_size = hit[0,2]
            protein_size_range = range(1,protein_size)
            for i in hit:
                protein_size_range = list(filterfalse(lambda x: i[3] <= x <= i[4], protein_size_range)) # get query cov
            if (1-(len(protein_size_range)/protein_size))*100 > query_cov: # check if query cov for remaining hsps is enough
                ## append only the hits that pass evalue and pident
                valid_hits.append(hit)
                if protein[:-2] not in protein_hits: # same protein cant be counted twice for two alignments
                    protein_hits.append(protein[:-2])

def output_gff(input_valid_hits):
    gff_no_ids = {}
    gff_no_ids_count = {}
    for hit in input_valid_hits:
        orientation_dict = {}
        orientation_dict['-'] = 0
        orientation_dict['+'] = 0
        for i in hit[:,5:7]:
            if i[0] > i[1]:
                orientation_dict['-'] += abs(i[1]-i[0])
            else:
                orientation_dict['+'] += abs(i[1]-i[0])
        if orientation_dict['-'] > orientation_dict['+']:
            orientation = '-'
        elif orientation_dict['-'] < orientation_dict['+']:
            orientation = '+'
        else:
            orientation = '+' ## this shouldn't happen very often, only for tandem repeats, in which case just assign +
        scaffold = hit[0][0]
        gene_start = np.min(hit[:,5:7])
        gene_end = np.max(hit[:,5:7])
        gene_entry = [
            scaffold,
            'PAV_validation',
            'gene',
            gene_start,
            gene_end,
            '.',
            orientation,
            '.'
        ]
        mRNA_entry = [
            scaffold,
            'PAV_validation',
            'mRNA',
            gene_start,
            gene_end,
            '.',
            orientation,
            '.'
        ]
        if tuple(gene_entry) not in gff_no_ids:
            gff_no_ids[tuple(gene_entry)] = []
            gff_no_ids_count[tuple(gene_entry)] = 1
            gff_no_ids[tuple(gene_entry)].append(gene_entry)
            gff_no_ids[tuple(gene_entry)].append(mRNA_entry)
            for hsp in hit:
                start = min([hsp[5],hsp[6]])
                end = max([hsp[5],hsp[6]])
                if orientation == '+':
                    frame = (gene_start - start) % 3
                else:
                    frame = (gene_end - end) % 3
                exon_entry = [
                    scaffold,
                    'PAV_validation',
                    'exon',
                    start,
                    end,
                    '.',
                    orientation,
                    '.'
                ]
                cds_entry = [
                    scaffold,
                    'PAV_validation',
                    'CDS',
                    start,
                    end,
                    '.',
                    orientation,
                    frame
                ]
                gff_no_ids[tuple(gene_entry)].append(exon_entry)
                gff_no_ids[tuple(gene_entry)].append(cds_entry)
        else:
            gff_no_ids_count[tuple(gene_entry)] += 1

    gff = []

    for entry_count, gene_entry in enumerate(gff_no_ids):
        hit_count = gff_no_ids_count[gene_entry]
        gene_ID = 'ID='+str(entry_count)+'_'+str(hit_count)+';Name='+str(entry_count)+'_'+str(hit_count)
        mRNA_ID = 'ID='+str(entry_count)+'_'+str(hit_count)+'T0;Parent='+str(entry_count)+'_'+str(hit_count)
        parent_ID = 'Parent='+str(entry_count)+'_'+str(hit_count)
        for exon_cds in gff_no_ids[gene_entry]:
            if exon_cds[2] == 'gene':
                gff.append([
                    exon_cds[0], exon_cds[1], exon_cds[2],
                    exon_cds[3], exon_cds[4], exon_cds[5],
                    exon_cds[6], exon_cds[7], gene_ID
                ])
            elif exon_cds[2] == 'mRNA':
                gff.append([
                    exon_cds[0], exon_cds[1], exon_cds[2],
                    exon_cds[3], exon_cds[4], exon_cds[5],
                    exon_cds[6], exon_cds[7], mRNA_ID
                ])
            else:
                gff.append([
                    exon_cds[0], exon_cds[1], exon_cds[2],
                    exon_cds[3], exon_cds[4], exon_cds[5],
                    exon_cds[6], exon_cds[7], parent_ID
                ])

    with open(genome+'_'+og+'.gff3', 'w', newline = '') as output_csv:
        w = csv.writer(output_csv, delimiter = '\t')
        w.writerow(['##gff-version 3'])
        for row in gff:
            w.writerow(row)

expected_og = og.split('.')[0]

if len(protein_hits) < hit_count:
    print(genome + '\t' + expected_og + '\tno_tblastn_hit')
else:
    output_gff(valid_hits)