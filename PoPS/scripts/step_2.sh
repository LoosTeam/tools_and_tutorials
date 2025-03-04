#!/bin/bash

# Send notifications when job ends. Remember to update the email address!
#SBATCH --mail-user=abc123@ku.dk --mail-type=END,FAIL
#SBATCH --mem 80G

module purge
module use --prepend /projects/loos_group-AUDIT/apps/modules/modulefiles/
module load PoPS/v0.2

#Change path to the directory where you want to run PoPS
cd /projects/loos_group-AUDIT/data/pops_tutorial/

#Remember to update paths for files
pops.py \
 --gene_annot_path /projects/loos_group-AUDIT/data/pops_data/gene_annot_jun10.txt \
 --feature_mat_prefix outputs/pops_features \
 --num_feature_chunks 116 \
 --magma_prefix outputs/magma_gene_anal_Schizophrenia \
 --control_features_path /projects/loos_group-AUDIT/data/pops_data/features_jul17_control.txt \
 --out_prefix outputs/pops_out_Schizophrenia \
 --verbose