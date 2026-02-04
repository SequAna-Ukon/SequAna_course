© 2026 Abdoallah Sharaf

# nf-core

If you are not generally excited by Nextflow or programming, then the good news is that it will still be working with Nexflow by using the developed pipelines at [nf-core](https://nf-co.re/). nf-core is a community effort to collect a curated set of analysis pipelines built using Nextflow. It provides highly automated and optimized pipelines that guarantee the reproducibility of results for their users. Single users profit from portable, documented, and easy-to-use workflows.

Sure, not all analysis pipelines are available including genome assembly, but the good news is that a couple of raw reads-related pipelines are available, which can be used for our data. Then, let's take a look at it. 

> **Exercise**: You will find that there is considerable documentation on nf-core [here](https://nf-co.re/docs/usage/introduction). Also, please read carefully documentation of the nf-core [taxprofiler pipeline](https://nf-co.re/taxprofiler/1.2.2/)

i believe that after reading the pipeline documentation, you can run it by yourself but here i will brief some hands-out

Let's start from the very beginning using nf-core. We can use a pipeline line called [fetching](https://nf-co.re/fetchngs/1.12.0) to download the raw data from GeneBank. One advantage of using this pipeline is that it will prepare the metadata file for us after activating the falg ````--nf_core_pipeline taxprofiler````


> **Exercise** Try to download our sequencing raw reads for Aiptasia, which should now be available in the NCBI Sequence Read Archive (SRA) under the accession ```SRR32136522``` using the fetching pipeline. Feel free to download any raw reads that you may interested in.
- if somehow it doesn't work or takes a longer time then we going to use this one ````SRX27526683```` for the Gram-positive bacteria *Bordetella pertussis*.

````bash
nextflow run nf-core/fetchngs  -profile conda --input input.csv --nf_core_pipeline taxprofiler --outdir raw_reads
````

- Did you notice that we can use the conda package management system by using the flag ````-profile conda````, another advantage of using Nextflow. 

- Now, let's run the nf-core [taxprofiler pipeline](https://nf-co.re/taxprofiler/1.2.2/), but before we need to download a database that important to taxnomy classy the reads. For simplicity, we will download the smallest database, the Viral collection of [Kraken2 databases](https://benlangmead.github.io/aws-indexes/k2).

````bash
wget https://genome-idx.s3.amazonaws.com/kraken/k2_viral_20241228.tar.gz
````
- Then, you need to create a ````databases.csv```` file as following.

````
tool,db_name,db_params,db_path
kraken2,db2,--quick,/workspace/gitpod/hello-nextflow/k2_viral_20241228.tar.gz
````

- Finally run the pipeline

````bash
nextflow run nf-core/taxprofiler -r 1.2.2  -profile docker --input raw_reads/samplesheet/samplesheet.csv --databases ./databases.csv --outdir Aip_taxpro --run_kraken2  --run_krona --perform_longread_qc --perform_longread_hostremoval False --save_analysis_ready_fastqs
````

- This command will produce massive intermediate files, so running on a Gitpode instance may not be possible. So I already set and tested it and placed the results ````/home/bio16840/Results/Aip_taxpro/```` on SequAna's server, i used kraken2 ```core_nt Database``` for this run.


> **Exercise**: While we wait let's try to generate the DAG graph for ````nf-core/fetchngs```` and ````nf-core/taxprofiler```` pipelines.

- From now and onward, we going to work on the SequAna server.
