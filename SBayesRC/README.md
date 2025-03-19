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

SNP ids should match the LD reference. If you are using LD data provided by SBayesRC, then your `SNP` column should be **rsIDs**. 

## Other inputs

* `ld_folder` is a folder that contains the eigen-decomposition data for each LD block. All panels provided by SBayesRC are available at `/projects/loos_group-AUDIT/data/tool_data/sbayesrc_data/SBayesRCv2/LD/`. If you want to generate your own LD panel, refer to official documentation.

* `annot` is the annotation file, with columns being SNP ID, Intercept (a column of one), and annotation values (it's best to use TAB delimited text file). File available at `/projects/loos_group-AUDIT/data/tool_data/sbayesrc_data/SBayesRCv2/Annotation/annot_baseline2.2.txt`:

```{r, eval=FALSE, indent="   "}
SNP Intercept Coding Conserved CTCF
rs1001 1 0 0 1
rs1002 1 0 1 0
rs1003 1 0 0 0
```

## Running SBayesRC

Load required modules:

```bash
module load --auto singularity
```

I would recommend to only modify the parameters below, and not the command to run SBayesRC:

```bash
#SBayesRC settings
#input
input_dir="path/to/inputdir"
ma_file="$input_dir/your_summary_statistics" # GWAS summary in COJO format (the only input)

ld_folder="/projects/loos_group-AUDIT/data/tool_data/sbayesrc_data/SBayesRCv2/LD/ukbEUR_Imputed" # LD reference (for example UKB EUR)
annot="/projects/loos_group-AUDIT/data/tool_data/sbayesrc_data/SBayesRCv2/Annotation/annot_baseline2.2.txt" # Functional annotation

#output
output_dir="path/to/outputdir"
output_file="$output_dir/name_for_output_file"

```
**You can use the commands below as they are.**
### SBayesRC step 1 : Tidy

```bash
#Step 1 : Tidy
singularity run --bind $(pwd),"$input_dir","$output_dir","$ld_folder" --pwd $(pwd) \
/projects/loos_group-AUDIT/apps/dockerimages/sbayesrc.sif --ldm-eigen "$ld_folder" --gwas-summary "$ma_file" --impute-summary --out "$output_file"  --threads 4
```

### SBayesRC step 2 : Main

```bash
#Step 2 : Main
singularity run --bind $(pwd),"$input_dir","$output_dir","$ld_folder","$annot" --pwd $(pwd) \
/projects/loos_group-AUDIT/apps/dockerimages/sbayesrc.sif --ldm-eigen "$ld_folder" --gwas-summary "$output_file".imputed.ma --sbayes RC --annot "$annot" --out "$output_file" --threads 4
```