© 2026 Abdoallah Sharaf

# Comparative Genomics / Homology Exploration
### [OrthoFinder](https://github.com/davidemms/OrthoFinder)

OrthoFinder is a fast and comprehensive platform for comparative genomics. It finds orthogroups and orthologs, infers rooted gene trees for all orthogroups, and identifies all gene duplication events in those gene trees. It also infers a rooted species tree for the species being analyzed and maps the gene duplication events from the gene trees to branches in the species tree. OrthoFinder also provides comprehensive statistics for comparative genomic analyses. OrthoFinder is the most popular tool and simple to use and all you need to run it is a set of protein sequence files (one per species) in FASTA format.

### [OrthoMCL](https://orthomcl.org/orthomcl/app/static-content/[OrthoMCL](https://orthomcl.org/orthomcl/app/static-content/OrthoMCL/about.html)/about.html)
Also, a Popular tool but it's hard to setup locally 

### [OrthoLoger](https://orthologer.ezlab.org/)
gene orthology software behind [OrthoDB](https://www.orthodb.org/), i didn't test it.


### [FastOMA](https://github.com/DessimozLab/FastOMA?tab=readme-ov-file)

The OMA (**Orthologous MAtrix**) project is a method and database for the inference of orthologs among complete genomes. OMA’s inference algorithm consists of three main phases. The advantage of using OMA that it identifies [hierarchical orthologous groups ](https://omabrowser.org/oma/glossary/#g-hog)(“HOGs”), which groups of genes defined for particular [taxonomic ranges ](https://omabrowser.org/oma/glossary/#g-taxr) and identify all genes that have descended from a common ancestral gene in that taxonomic range. While the disadvantage is that it's slow the good news is that a new fast version [FastOMA](https://github.com/DessimozLab/FastOMA) baesed Nextflow.

- As usual, i run it to compare our assembly and the available annotated genome, as the tool requires the total predicted proteins and there is only one genome ```Aiptasia genome 1.1``` with the protein dataset available then I will use the different protein datasets of the same genome inferred from annotation source GenBank ```GCA_001417965.1``` and RefSeq ```GCF_001417965.1``` and i place the results on ```Comparative``` directory

Here is the best installation method for your reference, but as usual, I placed the required list of packages, ```conda_packages.txt```, in the ```Comparative``` directory.

````bash
git clone https://github.com/DessimozLab/FastOMA.git
mamba env create -n FastOMA -f FastOMA/environment-conda.yml
````
- FastOMA requires ```species_tree.nwk``` which can be NCBI common tree, that i get it using [ETE Toolkit](http://etetoolkit.org/) based on the taxid ```taxid.txt``` of the studied organisms 

````bash
cat taxid.txt | ete3 ncbiquery --tree > species_tree.nwk
````
> **Exercise:** Get the NCBI common tree for your interest organisms

- Run the pipeline locally
Running time: 1h 4m 26s
````bash
nextflow run ../software/FastOMA/FastOMA.nf --input_folder in_folder --output_folder Aip_OMA
````

> **Exercise:** Download the output file ```Aip_OMA``` from the server and investigate the results.

### [funnanotate compare](https://funannotate.readthedocs.io/en/latest/compare.html)
 
Another funnanotate script to compare your newly sequenced/assembled/annotated genome to other organisms. The impetus behind funannotate compare was that there was previously no way to compare multiple genomes easily. The disadvantage is that it requires a GenBank flat file format as input while GFF3 is the common output of many annotation tools.

### [Orthovein3](https://orthovenn3.bioinfotoolkits.net/home)

OrthoVenn3 is a powerful tool for comparative genomics analysis, a user-friendly web for full genome comparisons, annotation, and evolutionary analysis of orthologous clusters across multiple species. 

> **Exercise:** use OrthoVenn3 to compare our annotated genome and the available annotations ```GCA_001417965.1``` and ```GCF_001417965.1```

# Modularity 
Modularity is an important keystone in molecular evolution and indispensable for evolutionary innovation. Protein domains as the modules of proteins can be reused in different molecular contexts and therefore rearrangements of domains can create a broad functional diversity with just a few mutational steps.

### **[DomRates-Seq](https://domainworld.uni-muenster.de/programs/domrates-seq/index.html)**  
DomRates-Seq infers these rearrangement events of protein domains for a given phylogeny and calculates the rates of the related events.

> **Note:** I will use the input files from the FastOMA exercise.

- Filter isoforms and keep only one of the isoforms.

````bash
../Results/Comparative/software/dw-helper/build/isoformCleaner -i in_folder/proteome/Exaiptasia_diaphana.fa -o Exaiptasia_diaphana_clean.fa
````

- Domain annotation using [PfamScan](https://ftp.ebi.ac.uk/pub/databases/Pfam/Tools/)

> **Note:** You need to download Pfam 37.0 database.

````bash
mamba activate pfam
pfam_scan.pl -fasta Exaiptasia_diaphana_clean.fa -cpu 1 -outfile Exaiptasia_diaphana.dom -dir ../Results/Comparative/software/pfam/
````
- Running domRates-Seq

````bash
../Results/Comparative/software/domratesseq/build/domRatesSeq -t ../Results/Comparative/OMA/in_folder/species_tree.nwk -r ../Results/Comparative/OMA/in_folder/proteome/ -f .fa -g unclassified_Aiptasia -a ../Results/Comparative/DomRates/domain_scan/ -m ../Results/Comparative/software/domratesseq/tests/data/BLOSUM62.txt -o rates.txt -d -s statistics.txt -p 1
````

> **Exercise:** Download and explore the output files ```rates.txt```, ```statistics.txt``` and ```statistics_epd.txt```.

- Visualize the results
- this code requires graphic suppot, then you need to log out from the server ```exit``` and log in with ```ssh -Y```

````bash
mamba activate pfam
python ../Results/Comparative/software/domratesseq/src/visualization_domrates_tree.py -t ../Results/Comparative/OMA/in_folder/species_tree.nwk -s ../Results/Comparative/DomRates/statistics.txt -o DomRates.pdf
````

> **Exercise:** Download and explore the produced graph ```DomRates```.


- Tracking domain rearrangement events

Instead of presenting the domain rearrangement event of the whole phylogeny, We can explore the domain rearrangement events of the selected proteins.
````bash
../Results/Comparative/software/domratesseq/build/domRatesSeq -t ../Results/Comparative/OMA/in_folder/species_tree.nwk -r ../Results/Comparative/OMA/in_folder/proteome/ -f .fa -g unclassified_Aiptasia -a ../Results/Comparative/DomRates/domain_scan/ -m ../Results/Comparative/software/domratesseq/tests/data/BLOSUM62.txt -o rates.txt -d -s statistics.txt -p 1 -c 1 -i Aip_010716-T1,XP_020894300.1
````

> **Exercise:** Download and explore the new outputs ```statistics_tree.txt``` and ```statistics_itol.txt```, how we can visualize these.
