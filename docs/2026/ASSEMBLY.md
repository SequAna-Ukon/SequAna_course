© 2026 Abdoallah Sharaf

# De-novo assembly using ONT reads
We will use [Flye assemblyer](https://github.com/fenderglass/Flye) for this task  
- the Aiptasia genome size 394 Mega Base Pairs according to [Genomes on a Tree](https://goat.genomehubs.org/search?query=tax_name%28Aiptasia%29&result=taxon&includeEstimates=true&summaryValues=count&taxonomy=ncbi#tax_name(Aiptasia)) but this information based ansectory prediction. The following studes claims that it's arround 250-300 Mbp, i will consider the average 275 Mb

- [Baumgarten](https://www.pnas.org/doi/epdf/10.1073/pnas.1513318112)
- [Zimmermann](https://www.biorxiv.org/content/10.1101/2020.10.30.359448v1.full)

## Flye
- we going to try three different setups for flye and let's see the differences
> **Exercise:** Double-check the log file for each run. Go to the software page and try to understand the difference between the three options.

````bash
mamba activate assem_env
````

Running time: 156m9,730s

````bash
flye --nano-hq  Aip_clean.fq.gz --genome-size 275m --out-dir aip_flye_hq --scaffold
````
Running time: 185m47,878s
````bash
flye --nano-corr  Aip_clean.fq.gz --genome-size 275m --out-dir aip_flye_corr --scaffold
````

Running time: 184m37,942s

````bash
flye --nano-raw  Aip_clean.fq.gz --genome-size 275m --out-dir aip_flye_raw --scaffold
````


- It's recommended to use different assemblers on your data to compare assembles, CANU, Unicycler, or MaSuRCA are popular options but I will run CANU and try a new assembler NECAT

## [NECAT](https://github.com/xiaochuanle/NECAT)
- The software installed from the source and placed in the path ```/home/bio16840/Results/Assembly/software/NECAT/Linux-amd64/bin/```
- first, we need to create a configuration file

````bash
/home/bio16840/Results/Assembly/software/NECAT/Linux-amd64/bin/necat.pl config aip_config.txt 
````
- put the clean read path in file ```read_list.txt```
- you need to edit the following information using any text editor
````bash
PROJECT=Aip_NECAT
ONT_READ_LIST=/home/bio16840/Abdo/read_list.txt
GENOME_SIZE=275000000
THREADS=1
MIN_READ_LENGTH=1000
````

- Then run the reads correction step

running time: 125m49,472s
````bash
/home/bio16840/Results/Assembly/software/NECAT/Linux-amd64/bin/necat.pl correct aip_config.txt 
````
- The pipeline only corrects the longest 40X raw reads. The corrected reads are in the files ```Results/Assembly/aip_NECT/NECT_out/1-consensus/cns_iter${NUM_ITER}/cns.fasta```. The longest 30X corrected reads are extracted for assembly, which are in the file ```Results/Assembly/aip_NECT/NECT_out/1-consensus/cns_final.fasta```.

- Now, time for assembly
Running time: 53m24,029s
````bash
/home/bio16840/Results/Assembly/software/NECAT/Linux-amd64/bin/necat.pl assemble aip_config.txt 

````
- The assembled contigs are in the file ```Results/Assembly/aip_NECT/NECT_out/4-fsa/contigs.fasta```.

- Finally, contigs can be bridged (scaffolded) with
Running time: 4m30,344s
````bash
/home/bio16840/Results/Assembly/software/NECAT/Linux-amd64/bin/necat.pl bridge aip_config.txt 
````
- The bridged contigs are in the file ```Results/Assembly/aip_NECT/NECT_out/6-bridge_contigs/bridged_contigs.fasta```.

## [CANU](https://github.com/marbl/canu)
Running time: 310m6,996s

````bash
canu -d Aip_canu -p Aip genomeSize=275m  -nanopore  -trimmed -correct -assemble Aip_clean.fq.gz gridOptions="--cpus=1"
````

## [hifiasm](https://github.com/chhylp123/hifiasm)
- The tool was developed to work with HiFi reads but last year they released a new version to work with ONT reads Ultr-Long and simplex reads and it shows promising results. Then I will try it in the course this year.

Running time: 42m28,033s
````bash
../Results/Assembly/software/hifiasm/hifiasm -t50 --ont --dual-scaf -o aip_asm aip_clean.fq.gz

gfa_to_fasta.py Aip_asm.bp.p_ctg.gfa
````
# Genome assembly Polishing

For the time limitation I will not do polishing as there are many ways to do it but here I will recommend some tools and how to run it.

## [Dorado](https://github.com/abdo3a/dorado)

This is a very good tool, and it was developed by Oxford Nanopore itself. Unfortunately, it requires GPU resources, so I was not able to test it.

## [Medaka](https://github.com/nanoporetech/medaka) 
- Also developed by Nanopore and uses long-reads.

````bash
minimap2 -ax map-ont -t 1 assembly.fasta reads_CLEAN.fq.gz > aligned_reads.sam
samtools view -@ 50 -Sb aligned_reads.sam | samtools sort -@ 50 -o lreads.bam
samtools index lreads.bam
medaka_consensus -i lreads.bam -d assembly.fasta -o medaka_output -m r941_min_hac_g507 -t 1
````

## [Pilon](https://github.com/broadinstitute/pilon) 

- This tool is very recommended in case of the availability of sequencing short reads from the same sample.

````bash
bowtie2-build  --threads 1 assembly.fasta genome_index
bowtie2 -p 1 -x genome_index-1 reads_Illu_1.fastp.fastq.gz -2 reads_Illu_2.fastp.fastq.gz -S aligned_reads.sam
samtools view -@1 -S -b aligned_reads.sam > aligned_reads.bam
samtools sort -@1 -o sorted_reads.bam aligned_reads.bam
samtools index sorted_reads.bam
java -Xmx50G -jar pilon-1.24.jar --threads 1 --genome assembly.fasta  --frags sorted_reads.bam --output polished_assembly
````
# Scaffolding

- This optional step then I will skip it also but give you hint about it

## [Redundans](https://github.com/Gabaldonlab/redundans)

- This tool can you any of short or long reads or both for scaffolding. 

````bash
docker run -v `pwd`/reads:/reads:rw -it cgenomics/redundans:latest /root/src/redundans/redundans.py -v -i reads/*_{1,2}.clean.fastq.gz -f polished_assembly.fasta -o reads/assembly_scaff -l reads/ont_clean.fq.gz --minimap2scaffold  -t 1 --runmerqury
````

# Genome assembly assessment

````bash
mamba activate eval_env 
````
## [gfastats](https://github.com/vgl-hub/gfastats)
- Let's first get some assembly statistics to compare the different assemblies and decide which one will carry on the downstream analysis
````bash
gfastats [assembly].fasta 
````

> **Exercise:** Choose the best assembly to proceed. considering the balance between contiguity and completeness, aiming for a relatively small number of contigs with longer lengths that accurately represent the underlying genome structure and content.
 
> **Exercise:** Compare the produced genome assembly statistics with the ones in [Baumgarten](https://www.pnas.org/doi/epdf/10.1073/pnas.1513318112)

## [Bandage](https://rrwick.github.io/Bandage/)
- Time to visually check your assembly. Bandage is a GUI software, so you need to run it locally.
- Download the software and retrieve the assembly graph file in [.gfa] or [.fasta] for the selected assembly format from the server.
- Open file ----> choose the assembly graph file ----> Draw graph

> **Exercise:** Export the visualized picture of the assembly.

## busco 
- You can run BUSCO on a genome sequence but I prefer to do it based on the predicted protein sequences and the BTK tool will implement this information. However, you will  learn about these tools on the last day with Rob
