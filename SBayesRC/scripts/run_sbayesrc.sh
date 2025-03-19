!/bin/bash

# Send notifications when job ends. Remember to update the email address!
##SBATCH --mail-user=abc123@ku.dk --mail-type=END,FAIL
#SBATCH --cpus-per-task 8

module load --auto singularity

#SBayesRC settings
#input
input_dir="path/to/inputdir"
ma_file="$input_dir/your_summary_statistics" # GWAS summary in COJO format (the only input)

ld_folder="/projects/loos_group-AUDIT/data/tool_data/sbayesrc_data/SBayesRCv2/LD/ukbEUR_Imputed" # LD reference (for example UKB EUR)
annot="/projects/loos_group-AUDIT/data/tool_data/sbayesrc_data/SBayesRCv2/Annotation/annot_baseline2.2.txt" # Functional annotation

#output
output_dir="path/to/outputdir"
output_file="$output_dir/name_for_output_file"

#Step 1 : Tidy
singularity run --bind $(pwd),"$input_dir","$output_dir","$ld_folder" --pwd $(pwd) \
/projects/loos_group-AUDIT/apps/dockerimages/sbayesrc.sif --ldm-eigen "$ld_folder" --gwas-summary "$ma_file" --impute-summary --out "$output_file"  --threads 4

#Step 2 : Main
singularity run --bind $(pwd),"$input_dir","$output_dir","$ld_folder","$annot" --pwd $(pwd) \
/projects/loos_group-AUDIT/apps/dockerimages/sbayesrc.sif --ldm-eigen "$ld_folder" --gwas-summary "$output_file".imputed.ma --sbayes RC --annot "$annot" --out "$output_file" --threads 4