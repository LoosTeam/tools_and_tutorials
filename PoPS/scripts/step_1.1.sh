#!/bin/bash

# Send notifications when job ends. Remember to update the email address!
#SBATCH --mail-user=abc123@ku.dk --mail-type=END,FAIL

module purge
module use --prepend /projects/loos_group-AUDIT/apps/modules/modulefiles/
module load MAGMA/v1.10 

#Change path to the directory where you want to run PoPS
cd /projects/loos_group-AUDIT/data/pops_tutorial/

#Remember to update paths for files
magma \
 --annotate \
 --snp-loc example_data/Schizophrenia_sumstats.txt \
 --gene-loc /projects/loos_group-AUDIT/data/tool_data/pops_data/gene_annot_jun10_modified.txt \
 --out outputs/magma_annot_Schizophrenia