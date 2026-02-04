© 2026 Abdoallah Sharaf

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

# **Phylogenomic tree**
Sometimes, it is called a species tree that would usefully resolve any ambiguities within evolutionary relationships [Kapli et al. 2020](https://www.nature.com/articles/s41576-020-0233-0). There are two approaches to infer a species tree: 

#### I. The super-tree approach 
can be achieved by computing separate gene trees based on each gene alignment that can be inferred and the different trees can then be coalesced to produce the species tree [Kapli et al. 2020](https://www.nature.com/articles/s41576-020-0233-0). A coalescence phylogenetic tree can be generated if multiple homologs (paralogs) are identified in one or more species. Alignment concatenation can be done using various software or online tools such as [T-coffee server (Combine)](http://tcoffee.crg.cat/apps/tcoffee/do:combine). Then, [ASTRAL-III
tool](https://github.com/smirarab/ASTRAL/tree/MP) can be used for estimating a super ```coalescence``` tree given a set of gene trees. ASTRAL is statistically consistent under the multispecies coalescent model [Rabiee et al. 2019](https://linkinghub.elsevier.com/retrieve/pii/S1055790317308424).

#### II. The supermatrix approach

It's the most popular approach, sometimes referred also as the single-copy genes or phylogenomic approach. In this approach, the Single-copy
genes are aligned and concatenated into a supermatrix, which is analyzed to produce the species tree. Routinely, the identified BUSCO single-copy genes in all studied species can be used for this approach. The BUSCO developers provide [phylogenomics scripts](https://gitlab.com/ezlab/busco_usecases/-/tree/master/phylogenomics?ref_type=heads) to benchmark this analysis. Also, other interesting pipelines are available such as [BUSCO2Tree](https://github.com/niconm89/BUSCO2Tree) and [BUSCO Phylogenomics](https://github.com/jamiemcg/BUSCO_phylogenomics). Recently, a web-based tool also became available [BuscoPhylo](https://buscophylo.inra.org.ma/)


> **Exercise:** use [BuscoPhylo](https://buscophylo.inra.org.ma/) to compute Phylogenomic tree for our genome and the available assembles  ```GCA_001417965.1``` and ```GCF_001417965.1```



## Gene tree
Usually, this is done for the genes of interesting and/or significant biological functions to have a deeper look into its evolutionary routes. Maximum Likelihood (ML) and Bayesian Inference (BI) are the most accurate and recommended algorithms for phylogenetic analysis [Sardaraz et al. 2012](http://article.sapub.org/10.5923.j.bioinformatics.20120201.04.html). I chose to demonstrate IQ-TREE software for phylogenetic analysis using ML method. This software identifies and automatically removes genes or taxa that show compositional bias from the analysis [Kapli et al. 2020](https://www.nature.com/articles/s41576-020-0233-0). i picked the identified HOG (HOG:E0794750) sequences for Phylogenetic analysis following commands:

- You need to align the sequences of interest first using [Mafft](https://mafft.cbrc.jp/alignment/software/) or any other software.

````bash
mamba activate phylo_env

mafft --thread 1 --auto ../Results/Phylogeny/Aip_HOGE0794750.faa > Aip_HOGE0794750.fas
````
- It is necessary to infer the phylogeny based on the conserved regions. Homologous proteins can include some unaligned regions which are not inherited, and some other regions that may have evolved so fast that the correct multiple alignments will be difficult to infer. The software [trimAl](http://trimal.cgenomics.org/) will be used to remove these poorly aligned regions.

````bash
trimal -in Aip_HOGE0794750.fas -out Aip_HOGE0794750.phy -phylip -gappyout
````
- Phylogenetic Inference, For a robust phylogenetic analysis, more sequences standing for a wide range of taxonomic groups with a balanced number of sequences from each group are recommended. I used [IQ-TREE](http://www.iqtree.org/) it's the most popular software for this.

````bash
iqtree2 -s Aip_HOGE0794750.phy -m TEST -bb 1000 -nt 1
````
Running time: 28m59,543s
> **Exercise:** Visualize the computed tree file ```Aip_HOGE0794750.treefile``` on ```Phylogeny``` 

<details>
<summary>Hint</summary>

- You can use [FigTree](http://tree.bio.ed.ac.uk/software/figtree/) or [iTOL](https://itol.embl.de/).

