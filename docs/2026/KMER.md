© 2026 Abdoallah Sharaf

# Genome Kmer profiling

- Usually, this is for short-reads or high-accurate long reads as "HiFi technology" but let's give it a try.

- The developer of [Smudgeplot](https://github.com/KamilSJaron/smudgeplot), [Kamil S. Jaron](https://kamilsjaron.github.io/) supports us with a [full tuterial](https://docs.google.com/presentation/d/1cZXcdeurt3YGVvNdSTlFaIBhFRHWXFbaQHcu7y64zJY/edit#slide=id.g25ff9944340_0_633) about Smudgeplot but I share here i used profile Kmer using [genomescope2.0](https://github.com/tbenavi1/genomescope2.0).


-  First, we need to compute the histogram of k-mer frequencies. For this, we will use [FastK](https://github.com/thegenemyers/FASTK),  but you can use[KMC](http://sun.aei.polsl.pl/REFRESH/index.php?page=projects&project=kmc&subpage=download), or [jellyfish](http://www.genome.umd.edu/jellyfish.html).

````bash
mamba activate kmer_env
mkdir Aip_ONT_GS
FastK -v -t10 -k21 -M16 -T4 Aip_sub_400K.fastq.gz -NAip_ONT_GS/kmcdb
Histex -G Aip_ONT_GS/kmcdb > Aip_ONT_GS/kmer_k21.hist
````
- The next step is to  run the modeling with the R script ```genomescope.R```
````bash 
../Results/Kmer/software/genomescope2.0/genomescope.R -i Aip_ONT_GS/kmer_k21.hist -o Aip_ONT_GS -k 21
````
 
> **Exercise:** Download the output folder ```Aip_ONT_GS``` from the ```Results/Kmer``` directory and dicuss the plots.

- Also let's try generating a smudgeplot v0.4.0

````bash
mkdir Aip_ONT_smudge
FastK -v -t4 -k21 -M16 -T4 Aip_sub_400K.fastq.gz -NAip_ONT_smudge/FastK_Table (or you can use the kmcdb from previous analysis) 
smudgeplot.py hetmers -L 100 -t 4 -o Aip_ONT_smudge/kmerpairs --verbose Aip_ONT_smudge/FastK_Table
smudgeplot.py all -cov_min 100 -cov_max 200 -o Aip_ONT_smudge/Aip -t "Exaiptasia diaphana" Aip_ONT_smudge/kmerpairs_text.smu
````
> **Exercise:** Download the output folder ```Aip_ONT_smudge``` from the ```Results/Kmer``` directory and dicuss the plots.
