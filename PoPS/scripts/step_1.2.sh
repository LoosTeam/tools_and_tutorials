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
 --bfile /projects/loos_group-AUDIT/data/tool_data/magma_data/ref_panels/1000g/g1000_eur/g1000_eur \
 --gene-annot outputs/magma_annot_Schizophrenia.genes.annot \
 --pval example_data/Schizophrenia_sumstats.txt N=65967 \
 --gene-model snp-wise=mean \
 --out outputs/magma_gene_anal_Schizophrenia