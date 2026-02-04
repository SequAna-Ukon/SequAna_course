© 2026 Abdoallah Sharaf

## Visualizing genome assembly cobionts by running BlobToolKit locally

- BlobToolKit (BTK) is an amazing tool to assess assembly quality and visualize to check potential cobionts, a full handout for how to run it can be found [HERE](https://github.com/blobtoolkit/tutorials/tree/main/futurelearn). Also, a full online course for BTK is available as well for future reference [HERE](https://www.futurelearn.com/courses/eukaryotic-genome-assembly-how-to-use-blobtoolkit-for-quality-assessment). 
For the second round, i used the new [nextflow pipeline](https://pipelines.tol.sanger.ac.uk/blobtoolkit/0.2.0) for BTK.

- But i will try the very recent Nextflow version of the tool, for this we need to prepare the following first

- converts sequencing data to CRAM format
````bash
minimap2 -ax map-ont assembly.fasta raw_ONT/20240206_Apo_Aip_02/Apo_fastq_pass.fastq.gz -t 10 | samtools sort -@10 -O BAM -o coverage.bam -
samtools index coverage.bam
samtools view -@ 10 -T assembly.fasta -C -o Aip.cram coverage.bam
````
- Prepare a metadata [.yaml] [file](https://github.com/SequAna-Ukon/SequAna_course2024/blob/main/Aip.yaml)  

- Prepare a (csv) input [sheet](https://github.com/SequAna-Ukon/SequAna_course2024/blob/main/aip.csv)


- run this nextflow command

Running time: 6h 20m 32s
````bash
nextflow run blobtoolkit/main.nf -profile docker --input aip.csv --fasta assembly.fasta --yaml aip.yaml --accession Aip --taxon "Aiptasia sp" --taxdump taxdump --blastp reference_proteomes.dmnd --blastn ncbi/nt/ --blastx eference_proteomes.dmnd
````
- it's a computational-extensive analysis so i did it for you but You still need to view the data, i will start hosting the data and all what you need to do is:

````bash
#log out the server
exit
# Start Google Chrome from the remote machine (server)
ssh  -Y bio16840 google-chrome
#add the local host address in the browse bar
http://localhost:8001/view/aip_btk_be/dataset/aip_btk_be/blob
````
- Still, you can do this on your system but you need first downloading the analysis folder on your system.

````bash
mamba create -y -n btk python=3.9
mamba activate btk
pip install blobtoolkit
blobtools view --remote aip_btk_be
````

> **Exercise:** Navigate the results and test the different options. which contigs we should filter out?

- Double-check results after decontamination ````aip_btk_aft````

> **Note:** [The NCBI Foreign Contamination Screen (FCS) tool](https://github.com/ncbi/fcs) is now publicly available. It is a suite of tools designed to identify and remove contaminant sequences from genome assemblies. 

````bash
../Results/Genome_Eval/software/run_fcsadaptor.sh --fasta-input Aip_final.fasta  --output-dir Aip_FCS --euk
cat Aip_final.fasta | sudo python3 ../Results/Genome_Eval/software/fcs.py clean genome --action-report ./Aip_FCS/fcs_adaptor_report.txt --output Aip_clean.fasta --contam-fasta-out adap_contam.fasta
python3 ../Results/Genome_Eval/software/fcs.py screen genome --fasta Aip_clean.fasta --out-dir ./gx_out/ --gx-db gxdb --tax-id 2652724
cat Aip_clean.fasta  | python3 ../Results/Genome_Eval/software/fcs.py clean genome --action-report ./gx_out/blast.1582434.fcs_gx_report.txt --output Aip_fcs.fasta --contam-fasta-out contam.fasta
````
> **Exercise:** Explore the outputs ```fcs_adaptor_report.txt``` and ```Aip_final.2652724.fcs_gx_report.txt``` from ```Results/Genome_Eval/Aip_FCS```.

