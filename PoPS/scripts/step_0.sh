#!/bin/bash

# Send notifications when job ends. Remember to update the email address!
#SBATCH --mail-user=abc123@ku.dk --mail-type=END,FAIL
#SBATCH --mem 80G

module purge
module use --prepend /projects/loos_group-AUDIT/apps/modules/modulefiles/
module load PoPS/v0.2

#Change path to the directory where you want to run PoPS
cd /projects/loos_group-AUDIT/data/pops_tutorial/
mkdir outputs

#Remember to update paths for files
munge_feature_directory.py \
 --gene_annot_path /projects/loos_group-AUDIT/data/tool_data/pops_data/gene_annot_jun10.txt \
 --save_prefix outputs/pops_features \
 --max_cols 500