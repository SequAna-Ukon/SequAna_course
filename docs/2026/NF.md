© 2026 Abdoallah Sharaf

# Nextflow
Honestly, running fastp once on each of the samples is super annoying. I guess we could generate a bash script to do it for us, but that would be not very easy and it would likely run in parallel, and we'd still have to manually take care of the directory structures for the results, and keep track of which versions of the software we used etc. etc. etc. And this was just for one bioinformatic tool! A typical pipeline may have upwards of 10 tools used in sequence, with the outputs combined in certain ways.

What if I told you there was a better way?!

There is! It's called [Nextflow](https://www.nextflow.io/docs/latest/getstarted.html).

### Hello Nextflow

- As i'm a Nextflow ambassador, I'm going to use the official training hands-on [Hello Nextflow](https://training.nextflow.io/hello_nextflow/)

- Because of the time limitation I will go through Parts 1, 5, and 6 of the hands-on.

- Also, double-check the other nextflow sub-commands such as ````clean````, ````list```` and options such as ````-bg```` 

<details>
<summary>Hint Hello Containers</summary>

````
#!/usr/bin/env nextflow

params.character = 'turkey'

// Generate ASCII art with cowpy
process cowpy {
    container 'community.wave.seqera.io/library/cowpy:1.1.5--3db457ae1977a273'
    publishDir 'results', mode: 'copy
    input:
        val character
    output:
        path "cowpy.txt"
    script:
    """
    cowpy "Hello Containers" -c $character > cowpy.txt
    """
}
workflow {
    cowpy(params.character)
}
````
</details>

