# Tutorial for running PoPS on Esrum

PoPS is a gene prioritization method that can be applied to GWAS summary statistics. You can find the official Github [here](https://github.com/FinucaneLab/pops), and the publication [here](https://doi.org/10.1038/s41588-023-01443-6).

PoPS has been made availble as an environment module in the `loos_group-AUDIT` folder on Esrum. This tutorial describes how you can load PoPS and associated tools, and run the program from start to finish. You can find the tutorial scripts at `/projects/loos_group-AUDIT/data/tutorials/pops_tutorial/`.

The data used for this tutorial is a set of publicly available summary statistics for schizophrenia, same as that used in the paper. PoPS is run in 3 steps - 

- [Step 0: Munge features](#run-step-0-munge-features) - `munge_feature_directory.py` accepts a directory of feature files and processes them into a more efficient format for downstream usage.
- [Step 1: Generate MAGMA scores](#run-step-1-generate-magma-scores) - MAGMA analysis is performed in 2 steps, **annotation** and **gene analysis**, to generate gene-level association statistics that are used as input for PoPS. You can find the documentation [here](https://cncr.nl/research/magma/).
- [Step 2: Run PoPS](#run-step-2-run-pops) - `pops.py` is run using the MAGMA analysis output, and the processed feature files to generate gene priority scores.

## Loading modules
The modules PoPS and MAGMA need to be loaded to be able to access them. It is good practice to `purge` all loaded modules to avoid clashes in versions when loading new modules.

```
module purge
module use --prepend /projects/loos_group-AUDIT/apps/modules/modulefiles/
module load PoPS/v0.2
module load MAGMA/v1.10 
```
Loading these modules will give you access to the different scripts used for PoPS. You can use these commands to check if the modules are loading properly, and also to view additional flags for the tools: 
```
munge_feature_directory.py -h
pops.py -h
magma
```

## Run step 0: Munge features
This step processes the feature files and and converts them into a more efficient format for downstream usage. This command can be run as is, without any modifications. This step outputs several feature files with suffix `.txt` and `.npy`. 

This step can be run using the script [step_0.sh](scripts/step_0.sh). 

```
munge_feature_directory.py \
 --gene_annot_path /projects/loos_group-AUDIT/data/tool_data/pops_data/gene_annot_jun10.txt \
 --save_prefix outputs/pops_features \
 --max_cols 500
```
| Flag | Description |
|-|-|
| --gene_annot_path | Path to gene annotation table. For the purposes of this script, only require that there is an ENSGID column. Here we use `gene_annot_jun10.txt`, which is provided in the PoPS repository, and should be applicable to most tasks.  |
| --feature_dir | Directory where raw feature files live. Each feature file must be a tab-separated file with a header for column names and the first column must be the ENSGID. Will process every file in the directory so make sure every file is a feature file and there are no hidden files. Please also make sure the column names are unique across all feature files. The easiest way to ensure this is to prefix every column with the filename. ✏️ **_NOTE:_** Here the default features are those used in the manuscript, find link [here](https://github.com/FinucaneLab/pops/issues/7). |
| --nan_policy | What to do if a feature file is missing ENSGIDs that are in gene_annot_path. Takes the values "raise" (raise an error), "ignore" (ignore and write out with nans), "mean" (impute the mean of the feature), and "zero" (impute 0). Default is "raise" |
| --save_prefix | Prefix to the output path. For each chunk i, 2 files will be written: {save_prefix}_mat.{i}.npy, {save_prefix}_cols.{i}.txt. Furthermore, row data will be written to {save_prefix}_rows.txt |
| --max_cols | Maximum number of columns per output chunk. Default is 5000 |

## Run step 1: Generate MAGMA scores
MAGMA is performed in 2 steps, and the parameters shown here are specific to running PoPS.  

### Step 1.1 MAGMA `annotation`
The first step is a pre-processing step, which maps SNPs to genes. The mapping is based on genomic location, assigning a SNP to a gene if the SNP’s location falls inside the region provided for each gene; typically this region is defined by the transcription start and stop sites of that gene. This step outputs a `.genes.annot` file.

This step can be run using the script [step_1.1.sh](scripts/step_1.1.sh). 
```
magma \
 --annotate \
 --snp-loc example_data/Schizophrenia_sumstats.txt \
 --gene-loc /projects/loos_group-AUDIT/data/tool_data/pops_data/gene_annot_jun10_modified.txt \
 --out outputs/magma_annot_Schizophrenia
```
| Flag | Description |
|-|-|
| --annotate | Used to specify MAGMA annotation step |
| --snp-loc | SNP location file / GWAS summary statistics - The file should contain three columns: SNP ID, chromosome, and base pair position. These should be the first three columns in that file (additional columns are ignored). |
| --gene-loc | Gene location file - This file contains gene locations. Here we use `gene_annot_jun10_modified.txt` that is defined in build **GRCh37 (hg19)**, and derived from the `gene_annot_jun10.txt` file decribed in the previous step. You can use the same file for your analysis. |
| --out | Output prefix |


### Step 1.2 MAGMA `gene analysis`

In the gene analysis step the gene p-values and other gene-level metrics are computed. The gene analysis results are output into a formatted output file with `.genes.out` suffix. The same results plus gene correlations with neighbouring genes are stored in a `.genes.raw` file.

This step can be run using the script [step_1.2.sh](scripts/step_1.2.sh). 
```
magma \
 --bfile /projects/loos_group-AUDIT/data/tool_data/magma_data/ref_panels/1000g/g1000_eur/g1000_eur \
 --gene-annot outputs/magma_annot_Schizophrenia.genes.annot \
 --pval example_data/Schizophrenia_sumstats.txt N=65967 \
 --gene-model snp-wise=mean \
 --out outputs/magma_gene_anal_Schizophrenia
```

| Flag | Description |
|-|-|
| --bfile | LD reference panel - Here the LD reference panel used is 1000 genomes EUR population. Other MAGMA specific LD-panels are available at `/projects/loos_group-AUDIT/data/tool_data/magma_data/ref_panels/`.|
| --gene-annot | Gene annotation file from the output of the previous MAGMA annotation step. |
| --pval | GWAS summary statistics - It must be a plain text data file with each row corresponding to a SNP. MAGMA will look for SNP IDs and p-values in the SNP and P column respectively. |
| N | Sample size - Use `N`to specify sample size directly or `ncol` to specify sample size column in the summary statistics. |
| --out | Output prefix |


## Run step 2: Run PoPS

PoPS has several flags that can be modified, refer to [this section](#loading-modules) for help. This step outputs 3 files; `.coefs`, `.marginals`, and `.preds` files.

```
pops.py \
 --gene_annot_path /projects/loos_group-AUDIT/data/tool_data/pops_data/gene_annot_jun10.txt \
 --feature_mat_prefix outputs/pops_features \
 --num_feature_chunks 116 \
 --magma_prefix outputs/magma_gene_anal_Schizophrenia \
 --control_features_path /projects/loos_group-AUDIT/data/tool_data/pops_data/features_jul17_control.txt \
 --out_prefix outputs/pops_out_Schizophrenia \
 --verbose
```

| Flag | Description |
|-|-|
| --gene_annot_path | Path to tab-separated gene annotation file. Must contain ENSGID, CHR, and TSS columns. Here we use `gene_annot_jun10.txt`, which is provided in the PoPS repository, and should be applicable to most tasks. |
| --feature_mat_prefix | Prefix to the split feature matrix files, such as those outputted by munge_feature_directory.py. There must be .mat.*.npy files, .cols.*.txt files, and a .rows.txt file |
| --num_feature_chunks | The number of feature matrix chunks, such as those outputted by munge_feature_directory.py |
| --magma_prefix | Prefix to the gene-level association statistics outputted by MAGMA. There must be a .genes.out file and a .genes.raw file |
| --control_features_path | Optional path to list of features (one per line) to always include |
| --out_prefix | Prefix that results will be saved with. Will write out a .preds, .coefs, and .marginals file |
| --verbose | Set this flag to get verbose output |