# Tutorial for running FLAMES on Esrum

FLAMES is a gene prioritization method that predicts the most likely effector gene in a locus. You can find the official Github [here](https://github.com/Marijn-Schipper/FLAMES), and the publication [here](https://www.nature.com/articles/s41588-025-02084-7).

FLAMES has been made available as an environment module in the `loos_group-AUDIT` folder on Esrum. This tutorial describes how you can load FLAMES and run it in a script. You can find the tutorial scripts at `/projects/loos_group-AUDIT/data/tutorials/flames_tutorial/`.

FLAMES method builds on the result files from PoPS and MAGMA, so please refer to those tutorials before your run FLAMES. You will need the following files-

1. From MAGMA:
    - `.genes.annot` file from MAGMA **annotation** step
    - `.genes.out` file from MAGMA **gene analysis** step
    - `.genes.raw` file from MAGMA **gene analysis** step
    - `.gsa.out` file from MAGMA **gene level analysis** step
2. From PoPS: 
    - `.preds` file with the PoPS scores from the final PoPS step
