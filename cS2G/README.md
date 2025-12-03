# Tutorial for running cS2G on Esrum

cS2G is SNP-to-gene linking tool, which combines the strategies from many tools to find the most optimal gene targets for a variant. You can read more about the tool in [this paper](https://doi.org/10.1038/s41588-022-01087-y).

cS2G tool is available as an R script on Esrum along with all the data needed to run the tool, courtesy of [Raquel Sanz Martinez](mailto:raquel.martinez@sund.ku.dk) from the Kilpelainen group. 

To run cS2G, you need a list of coordinates for the variants you would like to investigate in GRCh37 (hg19), and a config file. The Rscript that performs cS2G does not need to be modified.

## Install R libraries

You need to first make sure that you have the following R libraries installed in your home folder:

```
install.packages(c("tidyverse", "dplyr", "GenomicRanges", "biomaRt", "data.table"))
```

You can refer to [official Esrum documentation](https://cbmr-data.github.io/esrum/tips/r.html#installing-r-modules) for help with doing this.

## Prepare the config file

The config file needs to have the following parameters, in exactly this sequence:

 1. Specify the path to the file with the coordinates for the variants. The name of the column should be `Coord` and the positions should be in the format `chr:position`. Optionally, there can also be a second column called `PIP` for fine mapped variants.
 2. Indicate whether the input variants are fine-mapped variants or not (specify YES or NO). NO is set as default.
 3. Indicate the normalised cS2G score threshold for gene prioritization. It must be a numeric value between 0 and 1. `>0.5` is set as default to be sure that the SNP has only one candidate causal gene (best gene approach).
 4. Indicate whether you want to output all the SNP-Gene links (without any filtering). YES is set as default.
 5. Specify the output path.

You can find a template config file at `/projects/loos_group-AUDIT/data/tutorials/cS2G_tutorial/scripts/config_file_cS2G.txt` and [here](scripts/config_file_cS2G.txt). 

## Running cS2G

You can run cS2G by running the Rscript located at `/projects/loos_group-AUDIT/data/tool_data/cS2G_data/script/S2G_v2.R`.

Here is an example bash script to run cS2G:
```
#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --time=30
#SBATCH --mail-user=xxxxxx@ku.dk --mail-type=END,FAIL

module purge
module load R --auto

Rscript /projects/loos_group-AUDIT/data/tool_data/cS2G_data/script/S2G_v2.R /projects/loos_group-AUDIT/data/tutorials/cS2G_tutorial/scripts/configuration_file_S2G.txt

```

You can find the template bash script at `/projects/loos_group-AUDIT/data/tutorials/cS2G_tutorial/scripts/run_cS2G.sh` and [here](scripts/run_cS2G.sh).

## Information from Raquel



If we use the normalised cS2G score threshold >0.5 (by default) the SNP has only one candidate causal gene (BEST GENE approach). 

But some variants can be linked to 2 genes. If you want to be less restrictive you can get the raw output (all links), 
and filter for the raw cS2G score to prioritize more genes (i.e. you can prioritize genes with a score >1). 

You can also check how many variants locate in the gene body (or promoter) of the target gene and how many are in distal regulatory regions. 
For the distal regulatory variants, you can also check how many S2G links are found by at least 2 of the functionally informed constituent S2G strategies used by cS2G.
 
Regarding the tissue or cell type information, only the ones with the maximum raw linking value are shown.
For the EpiMap biosample information check http://compbio2.mit.edu/epimap_vis/

When using fine-mapped data, the prioritized output is filtered for PIP>0.5