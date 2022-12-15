#!/bin/bash

## this script simply updates code by copying them over from the submodules, only for the author's use for maintaining the code repo

git submodule update --remote KVK-lab-scripts
git submodule update --remote pav_project_local

SLURM_SCRIPTS=KVK-lab-scripts/slurm
BASH_SCRIPTS=KVK-lab-scripts/bash
PYTHON_SCRIPTS=KVK-lab-scripts/python
WHEAT_BLAST_ANALYSIS_DIR=pav_project_local/pav_newest_wheat_blast_all
RICE_BLAST_ANALYSIS_DIR=pav_project_local/pav_newest_gladieux_only_fungap
CROSS_HOST_ANALYSIS_DIR=pav_project_local/cross_host_comparisons

## at_content
TARGET_DIR=at_content/rice_blast/
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp ${SLURM_SCRIPTS}/gc_content_per_gene.slurm $TARGET_DIR

TARGET_DIR=at_content/wheat_blast/
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp ${SLURM_SCRIPTS}/gc_content_per_gene_wheat_blast.slurm $TARGET_DIR

## call_pav_orthogroups
TARGET_DIR=call_pav_orthogroups/rice_blast/
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $RICE_BLAST_ANALYSIS_DIR/pipeline_methods/pav_w_tree_climbing.Rmd $TARGET_DIR

TARGET_DIR=call_pav_orthogroups/wheat_blast/
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $WHEAT_BLAST_ANALYSIS_DIR/pipeline_methods/pav_w_tree_climbing.Rmd $TARGET_DIR

## deletion_calling
TARGET_DIR=deletion_calling/rice_blast/
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $SLURM_SCRIPTS/sv_callers_PJ.slurm $TARGET_DIR
cp $SLURM_SCRIPTS/download_sra_and_map.slurm $TARGET_DIR
cp $BASH_SCRIPTS/run_delly.sh $TARGET_DIR
cp $BASH_SCRIPTS/run_lumpy.sh $TARGET_DIR
cp $BASH_SCRIPTS/run_manta.sh $TARGET_DIR
cp $BASH_SCRIPTS/run_wham.sh $TARGET_DIR

TARGET_DIR=deletion_calling/wheat_blast/
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $SLURM_SCRIPTS/sv_callers_wheat.slurm $TARGET_DIR
cp $SLURM_SCRIPTS/download_sra_and_map.slurm $TARGET_DIR
cp $BASH_SCRIPTS/run_delly.sh $TARGET_DIR
cp $BASH_SCRIPTS/run_lumpy.sh $TARGET_DIR
cp $BASH_SCRIPTS/run_manta.sh $TARGET_DIR
cp $BASH_SCRIPTS/run_wham.sh $TARGET_DIR

## deletion sizes
TARGET_DIR=deletion_sizes/
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $CROSS_HOST_ANALYSIS_DIR/cross_host_pav_differences/deletion_size.Rmd $TARGET_DIR

## pav counts
TARGET_DIR=pav_counts_comparison/
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $CROSS_HOST_ANALYSIS_DIR/cross_host_pav_differences/pav_counts.Rmd $TARGET_DIR

## pav density
TARGET_DIR=pav_gene_density/
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $CROSS_HOST_ANALYSIS_DIR/cross_host_pav_differences/cross_host_deletion_distance_plots.Rmd $TARGET_DIR

TARGET_DIR=pav_gene_density/rice_blast
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $RICE_BLAST_ANALYSIS_DIR/deletion_statistics/deletion_distance.Rmd $TARGET_DIR

TARGET_DIR=pav_gene_density/wheat_blast
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $WHEAT_BLAST_ANALYSIS_DIR/deletion_statistics/deletion_distance.Rmd $TARGET_DIR

## deletion_other_params
TARGET_DIR=deletion_other_params/rice_blast/
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $SLURM_SCRIPTS/gather_data_all_svs_rice_blast.slurm $TARGET_DIR
cp $BASH_SCRIPTS/average_coverage_files.sh $TARGET_DIR
cp $CROSS_HOST_ANALYSIS_DIR/del_param_dsns/del_params_dsns.Rmd $TARGET_DIR

TARGET_DIR=deletion_other_params/wheat_blast/
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $SLURM_SCRIPTS/gather_data_all_svs_wheat.slurm $TARGET_DIR
cp $BASH_SCRIPTS/average_coverage_files.sh $TARGET_DIR
cp $CROSS_HOST_ANALYSIS_DIR/del_param_dsns/del_params_dsns.Rmd $TARGET_DIR

## deletion_te_gene_density
TARGET_DIR=deletion_te_gene_density/rice_blast/
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $BASH_SCRIPTS/plot_profiler.sh $TARGET_DIR
cp $SLURM_SCRIPTS/plot_profiler_all_svs_rice_blast.slurm $TARGET_DIR
cp $CROSS_HOST_ANALYSIS_DIR/sv_profile_plots/profile_plots.Rmd $TARGET_DIR

TARGET_DIR=deletion_te_gene_density/wheat_blast/
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $BASH_SCRIPTS/plot_profiler.sh $TARGET_DIR
cp $SLURM_SCRIPTS/plot_profiler_all_svs_wheat_blast.slurm $TARGET_DIR
cp $CROSS_HOST_ANALYSIS_DIR/sv_profile_plots/profile_plots.Rmd $TARGET_DIR

## effector_annotation
TARGET_DIR=effector_annotation/
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $BASH_SCRIPTS/effector_predictor.sh $TARGET_DIR
cp $CROSS_HOST_ANALYSIS_DIR/other_params/compare_param_distributions.Rmd $TARGET_DIR
cp $RICE_BLAST_ANALYSIS_DIR/pipeline_methods/get_effector_og_list.ipynb $TARGET_DIR

## ngs_data_signal
TARGET_DIR=ngs_data_signal/rice_blast/
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $SLURM_SCRIPTS/expression_guy11.slurm $TARGET_DIR
cp $SLURM_SCRIPTS/histone_marks_guy11.slurm $TARGET_DIR
cp $SLURM_SCRIPTS/methylation_guy11.slurm $TARGET_DIR
cp $RICE_BLAST_ANALYSIS_DIR/random_forest/transfer_info_from_guy11.ipynb $TARGET_DIR
cp $SLURM_SCRIPTS/eccdnas_guy11.slurm $TARGET_DIR

TARGET_DIR=ngs_data_signal/wheat_blast/
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $SLURM_SCRIPTS/expression_b71.slurm $TARGET_DIR
cp $WHEAT_BLAST_ANALYSIS_DIR/random_forest/transer_info_from_b71.ipynb $TARGET_DIR

TARGET_DIR=ngs_data_signal/
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $CROSS_HOST_ANALYSIS_DIR/other_params/compare_param_distributions.Rmd $TARGET_DIR

## orthogroup_pca
TARGET_DIR=orthogroup_pca/
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $RICE_BLAST_ANALYSIS_DIR/lineage_differentiating_pavs/pca_heat_map_phylogeny/pav_pca.Rmd $TARGET_DIR

## pfam_go_annotation
TARGET_DIR=pfam_go_annotation/
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $SLURM_SCRIPTS/pfam_scan_per_proteome.slurm $TARGET_DIR
cp $SLURM_SCRIPTS/pannzer_single_core.slurm $TARGET_DIR

## pfam_go_enrichment
TARGET_DIR=pfam_go_enrichment/
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $RICE_BLAST_ANALYSIS_DIR/lineage_differentiating_pavs/pfam_enrichment/pfam_enrichment_plot.Rmd $TARGET_DIR
cp $RICE_BLAST_ANALYSIS_DIR/lineage_differentiating_pavs/pfam_enrichment/pfam_enrichment.ipynb $TARGET_DIR
cp $RICE_BLAST_ANALYSIS_DIR/lineage_differentiating_pavs/go_enrichment/assign_go_to_ogs_all_ogs.ipynb $TARGET_DIR
cp $RICE_BLAST_ANALYSIS_DIR/lineage_differentiating_pavs/go_enrichment/go_enrichment.Rmd $TARGET_DIR
cp $CROSS_HOST_ANALYSIS_DIR/other_params/compare_param_distributions.Rmd $TARGET_DIR

## phylogenies
TARGET_DIR=phylogenies/
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $SLURM_SCRIPTS/get_sco_msa.slurm $TARGET_DIR
cp $PYTHON_SCRIPTS/concatenate_msas.py $TARGET_DIR
cp $SLURM_SCRIPTS/fasttree_scos.slurm $TARGET_DIR

TARGET_DIR=phylogenies/rice_blast/
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $RICE_BLAST_ANALYSIS_DIR/pipeline_methods/plot_phylogeny.Rmd $TARGET_DIR

TARGET_DIR=phylogenies/wheat_blast/
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $WHEAT_BLAST_ANALYSIS_DIR/pipeline_methods/plot_phylogeny.Rmd $TARGET_DIR

## random forest model importances
TARGET_DIR=random_forest_model_importances
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $BASH_SCRIPTS/launch_rf_importances_parallel.sh $TARGET_DIR
cp $PYTHON_SCRIPTS/rf_importances_parallel.py $TARGET_DIR
cp $PYTHON_SCRIPTS/average_importances_results.py $TARGET_DIR
cp $CROSS_HOST_ANALYSIS_DIR/importances/importances_plots.Rmd $TARGET_DIR

## random_forest_models
TARGET_DIR=random_forest_models
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $BASH_SCRIPTS/launch_rf_parallel_single_host.sh $TARGET_DIR
cp $PYTHON_SCRIPTS/rf_perf_test_parallel.py $TARGET_DIR
cp $PYTHON_SCRIPTS/average_rf_results.py $TARGET_DIR
cp $CROSS_HOST_ANALYSIS_DIR/confusion_matrices/confusion_matrix.Rmd $TARGET_DIR

TARGET_DIR=random_forest_models/rice_blast
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $RICE_BLAST_ANALYSIS_DIR/random_forest/get_per_gene_info.Rmd $TARGET_DIR

TARGET_DIR=random_forest_models/wheat_blast
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $WHEAT_BLAST_ANALYSIS_DIR/random_forest/get_per_gene_info.Rmd $TARGET_DIR

## random forest cross host
TARGET_DIR=random_forest_models_cross_host_test
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $BASH_SCRIPTS/launch_rf_parallel_cross_host.sh $TARGET_DIR
cp $PYTHON_SCRIPTS/rf_perf_test_cross_host.py $TARGET_DIR
cp $PYTHON_SCRIPTS/average_rf_results.py $TARGET_DIR
cp $CROSS_HOST_ANALYSIS_DIR/confusion_matrices/confusion_matrix.Rmd $TARGET_DIR

## random forest incorrect predictions heatmap
TARGET_DIR=random_forest_incorrect_preds
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $CROSS_HOST_ANALYSIS_DIR/model_errors/rice_blast_model_wrong_preds.Rmd $TARGET_DIR
cp $SLURM_SCRIPTS/rf_cross_host_output_predictions.slurm $TARGET_DIR
cp $PYTHON_SCRIPTS/rf_perf_test_cross_host_output_preds.py $TARGET_DIR

## random_forest_variable_dependence
TARGET_DIR=random_forest_variable_dependence
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $RICE_BLAST_ANALYSIS_DIR/random_forest/dependency_matrix/cor_matrices.Rmd $TARGET_DIR
cp $RICE_BLAST_ANALYSIS_DIR/random_forest/dependency_matrix/dependence_heatmaps.Rmd $TARGET_DIR
cp $SLURM_SCRIPTS/generate_dependence_matrix.slurm $TARGET_DIR
cp $PYTHON_SCRIPTS/output_train_test.py $TARGET_DIR
cp $PYTHON_SCRIPTS/dependencies_per_column.py $TARGET_DIR

## te gene distance
TARGET_DIR=te_gene_distance/rice_blast
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $RICE_BLAST_ANALYSIS_DIR/distance/pav_distances.Rmd $TARGET_DIR

TARGET_DIR=te_gene_distance/wheat_blast
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $WHEAT_BLAST_ANALYSIS_DIR/distance/pav_distances.Rmd $TARGET_DIR

TARGET_DIR=te_gene_distance
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $CROSS_HOST_ANALYSIS_DIR/distance/cross_host_pav_distance_plots.Rmd $TARGET_DIR

## validate missing orthogroups
TARGET_DIR=validate_missing_orthogroups/rice_blast
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $RICE_BLAST_ANALYSIS_DIR/pipeline_methods/print_pav_for_validation.Rmd $TARGET_DIR

TARGET_DIR=validate_missing_orthogroups/wheat_blast
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $WHEAT_BLAST_ANALYSIS_DIR/pipeline_methods/print_pav_for_validation.Rmd $TARGET_DIR

TARGET_DIR=validate_missing_orthogroups/
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $BASH_SCRIPTS/tblastn_validation_launch_script.sh $TARGET_DIR
cp $BASH_SCRIPTS/tblastn_validation.sh $TARGET_DIR
cp $PYTHON_SCRIPTS/make_single_file_from_og_dir.py $TARGET_DIR
cp $PYTHON_SCRIPTS/parse_tblastn_hits.py $TARGET_DIR
cp $PYTHON_SCRIPTS/parse_blastp_hits.py $TARGET_DIR

## fungap
TARGET_DIR=genome_annotation
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $SLURM_SCRIPTS/run_fungap.slurm $TARGET_DIR
cp $SLURM_SCRIPTS/process_fungap_out.slurm $TARGET_DIR
cp $BASH_SCRIPTS/fungap_launcher.sh $TARGET_DIR
cp $PYTHON_SCRIPTS/process_gffs_for_orthofinder.py $TARGET_DIR
cp $PYTHON_SCRIPTS/process_protein_sequences_for_orthofinder.py $TARGET_DIR

## orthogrouping
TARGET_DIR=orthogrouping
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $BASH_SCRIPTS/launch_orthofinder_blast.sh $TARGET_DIR
cp $SLURM_SCRIPTS/orthofinder_blast.slurm $TARGET_DIR
cp $SLURM_SCRIPTS/full_orthofinder_run.slurm $TARGET_DIR

## te annotation
TARGET_DIR=te_annotation/rice_blast
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $SLURM_SCRIPTS/repeatmasker_rice_blast.slurm $TARGET_DIR

TARGET_DIR=te_annotation/wheat_blast
if [ -d $TARGET_DIR ]; then rm -r $TARGET_DIR; fi && mkdir -p $TARGET_DIR
cp $SLURM_SCRIPTS/repeatmasker_wheat_blast.slurm $TARGET_DIR