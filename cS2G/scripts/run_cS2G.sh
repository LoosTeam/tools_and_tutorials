#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --time=30
#SBATCH --mail-user=xxxxxx@ku.dk --mail-type=END,FAIL

module purge
module load R/4.5.1 --auto

Rscript /projects/loos_group-AUDIT/data/tool_data/cS2G_data/script/S2G_v2.R /projects/loos_group-AUDIT/data/tutorials/cS2G_tutorial/scripts/config_file_cS2G.txt