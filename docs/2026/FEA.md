© 2026 Abdoallah Sharaf

# Functional Enrichment Analysis
### [goatools](https://github.com/tanghaibao/goatools)

This package contains a Python library to analyze the enrichment of GO terms, based on Fisher's exact test, and included are multiple test corrections such as FDR Benjamini/Hochberg. The package can do many analyses but we are interested in the script to ```Find GO enrichment of genes under study``` [find_enrichment](https://github.com/tanghaibao/goatools/blob/main/doc/md/README_find_enrichment.md)

It can filter on the significance of (e)nrichment or (p)urification. it can report various multiple testing corrected p-values as well as the false discovery rate.


Running time: 2m20,394s 
````bash
mamba activate enrich_env
find_enrichment.py ../Results/Enrichment/study.txt ../Results/Enrichment/population.txt ../Results/Enrichment/association.txt --pval=0.05 --method=fdr_bh --pval_field=fdr_bh --outfile=Aip_goatool.tsv
````
Where:

```
study.txt               # the predicted protein id in a study, I will use all annotated proteins with GO term but you could use any subset 
population.txt          # all predicted protein id names.  
association.txt         # an association file that maps a protein id names to a GO category.
--pval=0.05             # print pvalue's < 0.05
--method=fdr_bh         # Use Benjamini-Hochberg multiple test correction on uncorrected p-values
--pval_field=fdr_bh     # print fdr_bh values < 0.05 (rather than uncorrected pvalues)
--outfile=FILENAME.tsv  # Write to a tab-seperated file
```

> **Exercise:** Run the analysis and check the output

> **Note:** The e in the "Enrichment" column means "enriched" - the concentration of GO term in the study group is significantly higher than those in the population. The "p" stands for "purified" - a significantly lower concentration of the GO term in the study group than in the population.


### [topGO](https://bioconductor.org/packages/release/bioc/html/topGO.html)

topGO is a popular R Bioconductor package that provides tools for testing GO terms while accounting for the topology of the GO graph. Different test statistics and different methods for eliminating local similarities and dependencies between GO terms can be implemented and applied. I find [THIS](https://github.com/lyijin/topGO_pipeline/tree/master?tab=readme-ov-file) pipeline with ready-to-use scripts but I never try it. 

- Another handy tool to summarize and visualize the long lists of produced Gene Ontology terms is [REVIGO](http://revigo.irb.hr/). 

> **Exercise:** summarize the top Molecular Function (MF) Gene Ontology terms with fdr_bh values ```0.0``` produced from goatools using REVIGO

<details>
<summary>Hint</summary>

````bash
grep 'MF' file.tsv | cut -f1,10|grep -w '0.0'
````
</details>
