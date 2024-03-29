# Code for manuscript on presence-absence variation in Magnaporthe oryzae

This repository contains the code for a manuscript on presence-absence variation in Magnaporthe oryzae which has been published on bioRxiv here:
[Distinct genomic contexts predict gene presence-absence variation in 
different pathotypes of a fungal plant pathogen](https://www.biorxiv.org/content/10.1101/2023.02.17.529015v1.full.pdf)

The repository is organized such that each directory represents one type of analysis in the manuscript.

Within these directories, `.slurm`, `.sh`, and `.py` scripts were used for job submission and data processing on our computing cluster. These were largely used for gathering and generating data and high level analyses.

`.Rmd` and `.ipynb` are notebooks that were run locally. These contain lightweight analyses run locally.

`.Rmd` files contain the scripts used for generating figures for the manuscript.

All files used as inputs for `.Rmd` and `.ipynb` files are available on Zenodo under the DOI 10.5281/zenodo.7444380

All directories and scripts are described below:

- `gc_content/` - calculate gc content for rice and wheat blast genes and flanking regions
    - `rice_blast/`
        - `gc_content_per_gene.slurm`
        - `generate_gc_table_per_genome.py`
    - `wheat_blast/`
        - `gc_content_per_gene_wheat_blast.slurm`
        - `generate_gc_table_per_genome.py`
- `call_pav_orthogroups/` - define pav orthogroups using phylogeny and validated pavs for each rice and wheat blast lineage
    - `rice_blast/`
        - `pav_w_tree_climbing.Rmd`
    - `wheat_blast/`
        - `pav_w_tree_climbing.Rmd`
- `deletion_calling/` - call genomic deletions using various SV callers and Illumina sequencing datasets
    - `rice_blast/`
        - `sv_callers_PJ.slurm` - call genomic deletions using various SV callers and Illumina sequencing datasets in rice blast
        - `download_sra_and_map.slurm` - script to download and map Illumina data to genome
        - `run_delly.sh` - run delly sv caller
        - `run_lumpy.sh` - run lumpy sv caller
        - `run_manta.sh` - run manta sv caller
        - `run_wham.sh` - run wham sv caller
    - `wheat_blast/`
        - `sv_callers_wheat.slurm` - call genomic deletions using various SV callers and Illumina sequencing datasets in wheat blast
        - `download_sra_and_map.slurm` - script to download and map Illumina data to genome
        - `run_delly.sh` - run delly sv caller
        - `run_lumpy.sh` - run lumpy sv caller
        - `run_manta.sh` - run manta sv caller
        - `run_wham.sh` - run wham sv caller
- `deletion_sizes/` - calculate and plot density histogram of genomic deletion sizes in rice and wheat blast
    - `deletion_size.Rmd`
- `pav_counts_comparison/` - count and plot barplot of number of pav orthogroups in rcie and wheat blast
    - `pav_counts.Rmd`
- `pav_gene_density/` - measure distance to nearest pav/conserved gene for pav/conserved genes in wheat and rice blast and plot
    - `cross_host_deletion_distance_plots.Rmd` - plot 2d density plot of distances
    - `rice_blast/`
        - `deletion_distance.Rmd` - measure distances in rice blast
    - `wheat_blast/`
        - `deletion_distance.Rmd` - measure distance in wheat blast
- `deletion_other_params/` - measure ngs signal, gc content and other params for genomic deletions in rice and wheat blast and plot
    - `rice_blast/`
        - `gather_data_all_svs_rice_blast.slurm` - measure parameters/features for genomic deletions in rice blast
        - `average_coverage_files.sh` - average signal from ngs data for genomic deletions
        - `del_params_dsns.Rmd` - plot density histograms of params for genomic deletions
    - `wheat_blast/`
        - `gather_data_all_svs_wheat.slurm` - measure parameters/features for genomic deletions in rice blast
        - `average_coverage_files.sh` - average signal from ngs data for genomic deletions
        - `del_params_dsns.Rmd` - plot density histograms of params for genomic deletions
- `deletion_te_gene_density/` - calculate gene and te density across genomic deletions and generate profile plots
    - `rice_blast/`
        - `plot_profiler.sh` - generate tab delineated file representing te and gene density across genomic deletions
        - `plot_profiler_all_svs_rice_blast.slurm` - create feature files and prepare for te and gene density measures
        - `profile_plots.Rmd` - generated profile plots from density data
    - `wheat_blast/`
        - `plot_profiler.sh` - generate tab delineated file representing te and gene density across genomic deletions
        - `plot_profiler_all_svs_wheat_blast.slurm` - create feature files and prepare for te and gene density measures
        - `profile_plots.Rmd` - generated profile plots from density data
- `effector_annotation/` - identify effectors in rice and wheat blast proteomes and compare number of pav/conserved genes with effector annotations
    - `effector_predictor.sh` - predict effectors using signalp/tmhmm/effectorp
    - `compare_param_distributions.Rmd` - compare number of genes with signalp/tmhmm/effectorp amongst pav/conserved genes
    - `get_effector_og_list.ipynb` - annotate effector orthogroups based off of number of orthologs with effector annotation
- `ngs_data_signal/` - calculate ngs signal for pav and conserved genes in rice and wheat blast and plot density histograms to compare
    - `compare_param_distributions.Rmd` - plot density histograms of ngs signal for pav and conserved genes
    - `rice_blast/`
        - `expression_guy11.slurm` - measure expression of pav and conserved genes
        - `histone_marks_guy11.slurm` - measure histone marks for pav and conserved genes
        - `methylation_guy11.slurm` - measure methylation of pav and conserved genes
        - `transfer_info_from_guy11.ipynb` - transfer ngs signal of genes to their orthogroups
        - `eccdnas_guy11.slurm` - measure eccdna signal of pav and conserved genes
    - `wheat_blast/`
        - `expression_b71.slurm` - measure expression of pav and conserved genes
        - `transer_info_from_b71.ipynb` - transfer ngs signal of genes to their orthogroups
- `orthogroup_pca/` - generate pca using pav of orthogroups
    - `pav_pca.Rmd`
- `pfam_go_annotation/` - annotate pfam domains and go terms and compare number of pav/conserved genes with annotations
    - `pfam_scan_per_proteome.slurm` - run pfam scan on proteomes to get pfam domains
    - `pannzer_single_core.slurm` - run go annotation using pannzer2
    - `compare_param_distributions.Rmd` - plot comparisons of number of genes with pfam/go annotations between pav and conserved genes
- `pfam_nlr_go_enrichment/` - calculate and plot enrichment of specific pfam domains and go terms, as well as nlr enrichment, in lineage-differentating orthogroups
    - `pfam_enrichment_plot.Rmd` - plot pfam enrichment in lineage-differentiating orthogroups
    - `pfam_nlr_enrichment.ipynb` - calculate pfam enrichment and nlr enrichment in lineage-differentiating orthogroups
    - `assign_go_to_ogs_all_ogs.ipynb` - transfer go term annotations from genes to ogs
    - `go_enrichment.Rmd` - plot go enrichment in lineage-differentiating orthogroups
- `phylogenies/` - generate and plot phylogenies for rice and wheat blast lineages
    - `get_sco_msa.slurm` - generate msa from single copy orthologs
    - `concatenate_msas.py` - concatenate msas of single copy orthologs into single msa for phylogeny
    - `fasttree_scos.slurm` - generate fasttree from msa of scos
    - `rice_blast/`
        - `plot_phylogeny.Rmd` - plot phylogenies and highlight lineages
    - `wheat_blast/`
        - `plot_phylogeny.Rmd` - plot phylogenies and highlight lineages
- `random_forest_model_importances/` - measure and plot affect of permuting variables in rf model on f1 (importances)
    - `launch_rf_importances_parallel.sh` - script to laucnh importances calculations in parallel
    - `rf_importances_parallel.py` - generate random forest model and calculate importances of each variable
    - `average_importances_results.py` - average results of importances calculations
    - `importances_plots.Rmd` - plot importances against each other
- `random_forest_models/` - generate random forest models that predict pav genes using many features of these genes and plot metrics
    - `launch_rf_parallel_single_host.sh` - launch many random forest model calculation in parallel
    - `rf_perf_test_parallel.py`- calculate random forest model from parameters
    - `average_rf_results.py` - average result metrics from random forest model calculations
    - `confusion_matrix.Rmd` - plot confusion matrix for average results of random forest models
    - `rice_blast/`
        - `get_per_gene_info.Rmd` - gather features and pav/non-pav label for all genes in rice blast
    - `wheat_blast/`
        - `get_per_gene_info.Rmd` - gather features and pav/non-pav label for all genes in wheat blast
- `random_forest_models_cross_host_test/`
    - `launch_rf_parallel_cross_host.sh` - launch many cross host rf tests in parallel and average results
    - `rf_perf_test_cross_host.py` - generate random forest model from one host and use it to generate predictions for another host, calculate results and metrics
    - `average_rf_results.py` - average results and metrics
    - `confusion_matrix.Rmd` - plot confusion matrix for average results of random forest models
- `random_forest_incorrect_preds/` - generate predictions from rf model generated with one host and tested on another host and plot 2d density plot
    - `wrong_preds_heatmap.Rmd` - plot 2d density plot of distance to nearest pav gene for correct and incorrect predictions from cross host random forest model tests
    - `rf_cross_host_output_predictions.slurm` - generate rf model with one host, generate predictions for genes from another host 
    - `rf_perf_test_cross_host_output_preds.py` - generate rf model with one host, generate predictions for genes from another host 
    - `rice_blast/`
        - `deletion_distance.Rmd` - measure distance to nearest pav/conserved gene for pav/conserved genes in rice blast
    - `wheat_blast/`
        - `deletion_distance.Rmd` - measure distance to nearest pav/conserved gene for pav/conserved genes in wheat blast
- `random_forest_variable_dependence/` - calculate correlations and variable dependences for rice rf model and plot
    - `cor_matrices.Rmd` - generate variable correlations for rice rf model and plot
    - `dependence_heatmaps.Rmd` - generate heatmap of variable dependences for rf model
    - `generate_dependence_matrix.slurm` - calculate variable dependences for rf model
    - `output_train_test.py` - output training and testing data for rf model for calculating variable dependences in parallel
    - `dependencies_per_column.py` - calculate variable dependences for rf model
- `te_gene_distance/` - calculate and plot distances of pav/conserved genes to nearest te and nearest gene
    - `cross_host_pav_distance_plots.Rmd` - generate 2d scatterplot of pav/conserved genes distances to nearest gene/te
    - `rice_blast/`
        - `pav_distances.Rmd` - calculate distances of pav/conserved genes to nearest te and nearest gene
    - `wheat_blast/`
        - `pav_distances.Rmd` - calculate distances of pav/conserved genes to nearest te and nearest gene
- `validate_missing_orthogroups/` - get missing orthogroups from orthofinder output, and validate them using tblastn/blastp
    - `tblastn_validation_launch_script.sh` - generate commands for validation of missing orthogroups and parallelization
    - `tblastn_validation.sh` - use blastp and tblastn to validate whether orthogroups are actually missing and check that hits actually match missing orthogroups
    - `make_single_file_from_og_dir.py` - used to concatenate all orthogroup sequences together and generate blast db
    - `parse_tblastn_hits.py` - parse and filter tblastn hits according to params
    - `parse_blastp_hits.py` - parse and filter blastp hits and check whether blastp hits match missing orthogroup
    - `rice_blast/`
        - `print_pav_for_validation.Rmd` - generate list of missing orthogroups from orthofinder for rice blast
    - `wheat_blast/`
        - `print_pav_for_validation.Rmd` - generate list of missing orthogroups from orthofinder for rice blast
- `genome_stats/` - generate table of genome assembly stats
    - `generate_assembly_stats_tables.slurm` - generate table of genome assembly stats
- `genome_annotation/` - example code for genome annotation of rice and wheat blast genome
    - `run_fungap.slurm` - fungap command
    - `process_fungap_out.slurm` - run scripts to process gffs and protein fungap output files
    - `fungap_launcher.sh` - used to launch fungap runs on all genomes
    - `process_protein_sequences_for_orthofinder.py` - remove stop codons from sequences, append genome and lineage name to protein names
    - `process_gffs_for_orthofinder.py` - append genome and lineage names to protein names and fix gff
- `orthogrouping/` - orthogrouping scripts
    - `launch_orthofinder_blast.sh` - generate orthofinder diamond commands for parallelization
    - `orthofinder_blast.slurm` - run orthofinder blast commands in parallel
    - `full_orthofinder_run.slurm` - finalize orthofinder run using pre-computed blast results
- `te_annotation/` - annotate tes in rice and wheat blast genomes
    - `rice_blast/`
        - `repeatmasker_rice_blast.slurm` - run repeatmasker rice blast genomes
    - `wheat_blast/`
        - `repeatmasker_wheat_blast.slurm` - run repeatmasker wheat blast genomes
- `feature_statistical_comparisons` - make tables of features of pav and conserved genes for MoO and MoT and perform statistical tests
    - `distances_stats.Rmd` - gather median distances to pav genes, tes, genes, and perform permutation tests
    - `param_categorical_stats_table.Rmd` - gather counts for categorical features of pav/conserved genes, perform chi-squared tests
    - `param_dsns_stats_table.Rmd` - gather various statistics for continuous features of pav/conserved genes, perform permutation tests
    - `genomic_deletion_param_dsns_stats_table.Rmd` - gather various statistics for continuous features of genomic deletions and baseline genomic regions, perform permutation tests
