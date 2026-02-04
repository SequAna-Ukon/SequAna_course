© 2026 Abdoallah Sharaf

# Searching and Downloading Genome Data using [NCBI Datasets](https://www.ncbi.nlm.nih.gov/datasets)

- NCBI released this new database [NCBI Datasets](https://www.ncbi.nlm.nih.gov/datasets), as a one-stop shop for finding, browsing, and downloading genomic sequences, annotations, and metadata. The database has a CL version which makes retrieving big data possible.

### Get genome metadata

````bash
mamba activate compar_env
datasets summary genome taxon "Exaiptasia diaphana" 
````
- let's have the output in a more human-readable style
````bash
datasets summary genome taxon "Exaiptasia diaphana"  --as-json-lines | dataformat tsv genome --fields accession,assminfo-name,annotinfo-name,annotinfo-release-date,organism-name
````
### Filtering by genome assembly properties

- Get metadata for the reference genomes only

````bash
datasets summary genome taxon "Exaiptasia diaphana"  --as-json-lines --reference | dataformat tsv genome --fields accession,assminfo-name,annotinfo-name,annotinfo-release-date,organism-name
````
- Get metadata for the annotated genomes only

````bash
datasets summary genome taxon "Exaiptasia diaphana"  --as-json-lines --annotated | dataformat tsv genome --fields accession,assminfo-name,annotinfo-name,annotinfo-release-date,organism-name
````
- Get metadata for genomes with the Assembly level of "complete genome" 

````bash
datasets summary genome taxon "Exaiptasia diaphana"  --as-json-lines --assembly-level complete| dataformat tsv genome --fields accession,assminfo-name,annotinfo-name,annotinfo-release-date,organism-name
````

- Get metadata for genomes released after January 1, 2020

````bash
datasets summary genome taxon "Exaiptasia diaphana"  --as-json-lines --released-after 01/01/2020| dataformat tsv genome --fields accession,assminfo-name,annotinfo-name,annotinfo-release-date,organism-name
````
### Download a genome data package
- Let's download some genomes
````bash
datasets download genome taxon "Exaiptasia diaphana" --filename Aip_dataset.zip
````
- Choosing which data files to include in the data package
````bash
datasets download genome taxon "Exaiptasia diaphana" --include protein  --filename Aip_prot.zip
````

> **Exercise:** Get some metadata for your genome of interest
