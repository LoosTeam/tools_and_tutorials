# Tutorial for running SBayesRC on Esrum

SBayesRC is a polygenic prediction method. Find official documentation [here](https://github.com/zhilizheng/SBayesRC).

SBayesRC is available as a docker image in the `loos_group-AUDIT` folder on Esrum and can be run using Singularity.

## Prepare summary statistics

SBayesRC requires summary statistics in **COJO format** (original scale without standardization for b and se) and a **TAB separated** file. The order of the columns should match the example below.

```
SNP A1 A2 freq b se p N
rs1001 A G 0.8493 0.0024 0.0055 0.6653 129850
rs1002 C G 0.0306 0.0034 0.0115 0.7659 129799
rs1003 A C 0.5128 0.0045 0.0038 0.2319 129830
```

SNP name should match LD reference. If you are using LD data provided by SBayesRC, then your `SNP` column should be **rsIDs**. 

## Other inputs

* `ld_folder` is a folder contains the eigen-decomposition data for each LD block, available at `/projects/loos_group-AUDIT/data/tool_data/sbayesrc_data/SBayesRCv2/LD/`. If you want to generate your own LD panel, refer to official documentation.

* `annot` is the annotation file, with columns being SNP ID, Intercept (a column of one), and annotation values (it's best to use TAB delimited text file). Available at `/projects/loos_group-AUDIT/data/tool_data/sbayesrc_data/SBayesRCv2/Annotation/annot_baseline2.2.txt`:

```{r, eval=FALSE, indent="   "}
SNP Intercept Coding Conserved CTCF
rs1001 1 0 0 1
rs1002 1 0 1 0
rs1003 1 0 0 0
```