# Intensive practical genome sequencing course, from basic scripting to advanced downstream analyses (BIO-16840)
## 21st - 27th March 2024

This markdown document will cover all aspects of the practical related to SequAna's intensive genomic course.

# Introduction
In this practical, we will process an Oxford nanopore sequencing (ONT) dataset of a symbionts-free strain of Aiptasia sp. [Exaiptasia diaphna] strain F003  that was generated earlier in SequAna's Lab. 
Aiptasia is a globally distributed genus of sea anemones in the Class Anthozoa. Similar to its relatives, stony corals, Aiptasia forms symbiotic relationships with microalgae of the family Symbiodiniaceae. As such, it is a popular model organism for studying the molecular and cellular basis of the cnidarian-algal symbiosis and several recent investigations into animal-microbiome studies.
It has several features that make it an ideal model organism for studies on marine symbioses: they are easily cultured in laboratories where they can reproduce both sexually and asexually. Asexual cloning, in particular, is a valuable ability as it allows large clonal populations to be obtained with relative ease. Additionally, they can also be cultured and maintained indefinitely in a symbiont-free state and can be re-infected by a variety of Symbiodiniaceae strains. The avaliable/refernce  genome for this species was sequenced using short-read technology and belongs to a different strain Aiptasia strain CC [(Baumgarten et al. 2015)](https://www.pnas.org/doi/full/10.1073/pnas.1513318112).

## The papers
Selected publications It would be a good idea to familiarize yourself with the papers before starting the practical work.
- [Wang et al. (2021)](https://www.nature.com/articles/s41587-021-01108-x).
- [Boughattas et al. (2021)](https://onlinelibrary.wiley.com/doi/10.1002/ece3.8447).
- [Willem et al. (2022)](https://onlinelibrary.wiley.com/doi/10.1111/tpj.15690).
- [Safar et al. (2023)](https://bmcbiotechnol.biomedcentral.com/articles/10.1186/s12896-023-00797-3).
- [Fleck et al. (2024)](https://www.nature.com/articles/s42003-023-05748-4).
## Location
The practical will take place in room M739 from 09.00-~18:00 on the 21st-27th of March. 

Abdoallah aka "Abdo", the current SequAna bioinformatician will be running the main practical and will be there to assist you. Moreover, some of the externally invited speakers will run virtually their mini-practice.

## Computing setup
You'll need access to a computer so you can finish this practical. While M739 does contain computers that use your laptops. Also, you could use it to log in to the
SequAna computational server. This is a very inconvenient way to work as your home directory is deleted after every session and it is not possible to install applications that use Graphical User Interfaces (GUI). However, we also already set up an online cloud environment (Gitpod) for this practical but it has limited computing and storage resources. This online cloud environment will mainly used for the scripting basic demonstration and the mini-practice. However, it's necessary to have your GitHub account to work with Gitpod, if you don't have one please do it now.

As such, it is strongly recommended that you bring a laptop to complete the practical. However, we will give you access to SequAna's computational server: SequAna_Students. connections details can be found [HERE](https://github.com/SequAna-Ukon/SequAna_course2024/wiki/Connecting-to-SequAna_Students'-computational-server:-sequana).

# Objectives

The main objective of this course is to empower participants with the theoretical and practical knowledge to sequence their genome of interest using ONT and analyze it, including a practical hand-out in the basics of the command line, scripting, and the use of computational tools for genome assemblies and several genome downstream analyses. 

The objective of this course is not for you to become proficient or masterful of the techniques. We will be covering (we have only 5 working days!), nor to perfectly create results for publication. The critical part is the journey, not the destination. Please feel free to take your time. Any proficiency gained in the techniques we cover will likely be extremely valuable to you as a research scientist.

We will work with the sequencing data generated from Aiptasia during this course to recapitulate several of their key findings to achieve this objective.

In doing so we will cover many broad informatic/bioinformatic techniques not limited to:

- Working on the command line interface (CLI), including working with package managers, docker images, and workflow management.
- Practicing on ONT library preparation strategies.
- Working with core bioinformatic tools to perform:
    - Genome assembly and assist its quality with different approaches.
    - Identify and mask DNA repeats.
    - Gene prediction and functional annotation.
    - Orthology Prediction and Phylogenetic Analysis.


We will provide resources for all topics we cover and you are encouraged to look at these
resources if you wish to further your knowledge of the topic.

# Structure of the practical
The course will be divided into 5 days. Each day we will work towards our end goal of recapitulating the results of the sequenced genome in the course. But remember, our goal is to learn along the way, not to get to the end. I would instead take our time on the journey that reaches the final results.

One of the most essential skills in computation biology/informatics is the effective
sourcing of reference material. I.e. good googling!

As such throughout the first two days, while you will be given a structure to follow, you will also be asked to work out how to do certain tasks on your own.
But don't worry, the SequAna bioinformatician will be there to help you when you get stuck. Much of what you're asked to do will be new to you and may feel challenging - that's normal.

Some packages take a long time to install so it's best to do this setup in advance. Then, we will install all requirements during the first two days while we introduce you to the bash and scripting basics. 

Last but not least, The program of the course is on the [WIKI](https://github.com/SequAna-Ukon/SequAna_course2024/wiki) page, with links to material and Zoom link for the external speakers, Enjoy the training.

© 2024 Abdoallah Sharaf

