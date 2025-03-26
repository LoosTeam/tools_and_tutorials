# Tutorial for running LDSC on Esrum

LDSC is a command line tool for estimating heritability and genetic correlation from GWAS summary statistics. LDSC also computes LD Scores.

Find official documentation [here](https://github.com/bulik/ldsc/tree/master).

To use this tool run the following commands:
```
module purge
module use --prepend /projects/loos_group-AUDIT/apps/modules/modulefiles/
module load ldsc
ldsc.py -h
munge_sumstats.py -h
make_annot.py -h
```

For details about usage and examples, please refer to the official documentation.

