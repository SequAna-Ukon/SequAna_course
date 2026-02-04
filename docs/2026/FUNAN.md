© 2026 Abdoallah Sharaf

# Gene prediction and functional annotation using [funannotate](https://funannotate.readthedocs.io/en/latest/).

Funannotate is a genome prediction, annotation, and comparison software package. The impetus for this software package was to be able to accurately and easily annotate a genome for submission. Existing tools require significant manual editing to comply with GenBank submission rules, thus funannotate is aimed at simplifying the gegenome submission process. Funannotate is a series of Python scripts that are launched from a Python wrapper script and implement several tools, then sometimes its installation could be a little bit tricky. However, I prepared some tips for the funannotate installation [HERE](https://github.com/SequAna-Ukon/SequAna_course2024/wiki/Funnanotate-installation-tips).

- as it is a very time-consuming analysis, I already did it before and I recorded here what I did for Aiptasia's genome you can find the results in the related directory ```Annotation```. Also, it requires the preparation of several evidence data as following

### Preparing RNASeq evidence 
I'm going to use the RNASeq datasets from [Jacobovitz et al. 2021](https://pubmed.ncbi.nlm.nih.gov/33927382/).

- Indexing the assembled genome

Running time: 1m54.085s
````bash
STAR --runThreadN 10 --runMode genomeGenerate --genomeDir Aip_index --genomeFastaFiles Aip_final.fasta --genomeSAindexNbases 10
````

- Mapping the RNA-Seq reads to the assembled genome

Running time: 14m49.585s  
````bash
while read i;do STAR --runThreadN 10 --genomeDir Aip_index --readFilesIn ${i}_1.fastq.gz ${i}_2.fastq.gz --readFilesCommand "gunzip -c" --outSAMtype  BAM SortedByCoordinate --outSAMstrandField intronMotif --outFilterIntronMotifs RemoveNoncanonical --outFileNamePrefix ${i}_ --limitBAMsortRAM 10000000000; done < list.txt
````

- Merge all mapping files

Running time: 34m29.487s
````bash
samtools merge Aip_RNASeqAll.STAR.bam SRR10546810_Aligned.sortedByCoord.out.bam SRR10546811_Aligned.sortedByCoord.out.bam SRR10546812_Aligned.sortedByCoord.out.bam SRR10546813_Aligned.sortedByCoord.out.bam SRR10546814_Aligned.sortedByCoord.out.bam SRR10546815_Aligned.sortedByCoord.out.bam
````
> **Exercise:** Check how many reads were mapped from this RNAseq datasets to our assembled genome.

> **Hint:**

````bash
samtools flagstat -@10 [file].bam
````
### Preparing expression evidence based on [StringTie2](https://ccb.jhu.edu/software/stringtie/)  

Running time: 15m28.159s
````bash
stringtie -p 10 -o Aip_RNASeqAll.Stringtie.gtf Aip_RNASeqAll.STAR.bam
````
- you can get the gtf file details "optional" using:

````bash
grep -v "#" Aip_RNASeqAll.Stringtie.gtf  | cut -f3 | sort | uniq -c
````

### Preparing transcript evidence

````bash
gtf_genome_to_cdna_fasta.pl Aip_RNASeqAll.Stringtie.gtf Aip_final.fasta > Aip_RNASeqAll.transcripts.fasta
````

### Preparing protein evidence

- Search for curated protein sequences for "Aipstia" on the [UniProt](https://www.uniprot.org/uniprotkb?fields=accession%2Creviewed%2Cid%2Cprotein_name%2Cgene_names%2Corganism_name%2Clength&query=aiptasia+sp&view=table) database and save them as "uniprot_Aiptasia.faa"

- Or download the latest lineage-/group-specfic protein set from [OrthoDB](https://bioinf.uni-greifswald.de/bioinf/partitioned_odb11/)

### tRNA prediction

````bash
tRNAscan-SE -E -I -H --detail --thread 50 -o trnascan-se.out -f trnascan-se.tbl -m trnascan-se.log  RE_mask/AiptasiaF003_V1.fasta.masked

EukHighConfidenceFilter -i trnascan-se.out -s trnascan-se.tbl -o eukconf -p filt
````
### Train Augustus 

This script is a wrapper for will use RNASeq data to train Augustus including genome-guided Trinity RNA-seq assembly followed by PASA assembly. For this all RNASeq data needs to be merged

> **Exercise:** How we can merge the RNA-Seq datasets?


Running time: 723m51,407s
````bash
funannotate train -i Aip_final.fasta -o funannotate_Aip --species "Aiptasia sp" -l Aip_RNASeqAll_1.fq -r Aip_RNASeqAll_2.fq --cpus 10 --memory 50G
````

## Gene prediction
- Now, let's run the gene prediction by implementing the prepared evidences. 

 
Running time: 440m59,049s
````bash
funannotate predict -i RE_mask/Aip_final.fasta.masked -s "Aiptasia sp" -o funannotate_Aip --name Aip --rna_bam ../Results/Annotation/Aip_RNASeqAll.STAR.bam --stringtie ../Results/Annotation/Aip_RNASeqAll.Stringtie.gtf --protein_evidence ../Results/Annotation/uniprot_Aiptasia.faa --transcript_evidence ../Results/Annotation/Aip_RNASeqAll.transcripts.fasta  --organism other --database ../Results/Annotation/software/ --busco_db metazoa --min_protlen 100 --cpus 10
````

- add UTR

Running time: 897m8,114s

````bash
funannotate update -i funannotate_Aip --cpus 1
````


### QC of the gene prediction 

> **Exercise:** Since it's not possible to reproduce the previous commands due to time and computational resource limitations, we going to work on the results that i produced earlier ```Results/Annotation/funannotate_Aip```. Copy it in your directory

- Get the prediction details from the annotation file (gff3)

````bash
grep -v "#" funannotate_Aip/update_results/Aiptasia_sp.gff3  | cut -f3 | sort | uniq -c
````
> **Exercise:** Are the numbers in line with the other studies?

- BUSCO scores
- Rob will give a whole talk about the tool and maybe a mini-practice but here is what I did for our annotation.

````bash  
#against eukaryota_odb10
busco -i funannotate_Aip/update_results/Aiptasia_sp.proteins.fa -m proteins -l eukaryota_odb10 -c 10 -o funannotate_Aip/Aip_busco_euka
#against metazoa_odb10
busco -i funannotate_Aip/update_results/Aiptasia_sp.proteins.fa -m proteins -l metazoa_odb10 -c 10 -o funannotate_Aip/Aip_busco_meta
#plot the results
mkdir funannotate_Aip/BUSCO_summaries
cp funannotate_Aip/Aip_busco_euka/short_summary.*.txt funannotate_Aip/BUSCO_summaries/
cp funannotate_Aip/Aip_busco_meta/short_summary.*.txt funannotate_Aip/BUSCO_summaries/
generate_plot.py -wd funannotate_Aip/BUSCO_summaries/
````
> **Exercise:** compares the scores with the genome one

- In the case of the RNA long read availability

````bash
funannotate train -i AiptasiaF003_V1.fasta -o funannotate_Aip_lRNA -l Aip_RNASeqAll_1.fq -r Aip_RNASeqAll_2.fq --species "Exaiptasia diaphana" --cpus 60 --memory 100G 

funannotate train -i AiptasiaF003_V1.fasta -o funannotate_Aip_lRNA --species "Exaiptasia diaphana" --nanopore_mrna apo_F003_trans_filtered.fastq.gz  --cpus 60 --memory 100G 

funannotate predict -i RE_mask/AiptasiaF003_V1.fasta.masked -s "Exaiptasia diaphna" -o funannotate_Aip_lRNA --name Aip --stringtie Aip_RNASeqAll.Stringtie.gtf --protein_evidence uniprot_Aiptasia.faa --transcript_evidence Aip_RNASeqAll.transcripts.fasta  --organism other --database ./funannotate_DB/ --busco_db metazoa --trnascan tRNA/trnascan_final.out --min_protlen 100 --cpus 60

funannotate update -i funannotate_Aip_lRNA --cpus 60

funannotate species -s aiptasia_sp -a funannotate_Aip_lRNA/predict_results/aiptasia_sp.parameters.json
````


## Functional annotation


- again it requires preparing some results then we use funannotate to implement it.

-  transmembrane topology and signal peptide predictor, which requires install phobius
Running time: 49m10,758s

````bash
../Results/Annotation/software/phobius/phobius.pl -short funannotate_Aip/update_results/Aiptasia_sp.proteins.fa > phobius.results.txt
````

- IterProScan
- i used the funnannotate command

Running time: 630m56,386s
  
````bash
funannotate iprscan -i funannotate_Aip -m docker -c 10
````

- eggnog-mapper
Running time: 20m18,770s

````bash
emapper.py --cpu 10 -m mmseqs --data_dir software/  -i funannotate_Aip/update_results/Aiptasia_sp.proteins.fa -o funannotate_Aip/update_results/Aip_eggnog
````

- Implement annotation using funannotate
Running time: 20m23,667s

````bash
funannotate annotate -i funannotate_Aip/ -s "Aiptasia sp" --busco_db  metazoa --eggnog funannotate_Aip/Aip_eggnog.emapper.annotations --iprscan funannotate_Aip/annotate_misc/iprscan.xml --phobius funannotate_Aip/phobius.results.txt --cpus 1
````
- Congrats, now you have a fully functionally annotated genome.

> **Exercise:** Investigate the final annotations files on the directory ```annotate_results```

**Note:** However, sometimes gene prediction using Funannotate does not perform well. In such cases, I recommend using an alternative approach, specifically one of the [Gaius-Augustus](https://github.com/Gaius-Augustus) tool family, with [BRAKER](https://github.com/Gaius-Augustus/BRAKER) being a particularly good option.

