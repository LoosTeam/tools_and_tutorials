# Tutorial for running FLAMES on Esrum

FLAMES is a gene prioritization method that predicts the most likely effector gene in a locus. You can find the official Github [here](https://github.com/Marijn-Schipper/FLAMES), and the preprint [here](https://www.medrxiv.org/content/10.1101/2023.12.23.23300360v2.full).

FLAMES has been made availble as an environment module in the `loos_group-AUDIT` folder on Esrum. This tutorial describes how you can load FLAMES and run it in a script. You can find the tutorial scripts at `/projects/loos_group-AUDIT/data/tutorials/flames_tutorial/`.

FLAMES method builds on the result files from PoPS and MAGMA, so please refer to those tutorials before your run FLAMES. You will need the following files-

1. From PoPS: 
    - `.preds` file with the PoPS scores
2. From MAGMA:
    - `.genes.out` file with gene analysis Z-scores from MAGMA **annotation** step
