© 2026 Abdoallah Sharaf
# Command Line interface (CLI)
## Requirements
You should already be familiar with working in bash on the command line.
See [HERE](https://rnabio.org/module-00-setup/0000/08/01/Unix/) for an excellent resource.

If you don't yet have access to a Unix-based operating system i.e Windows, you can install Windows Subsystem for Linux (WSL) according to the [THIS](https://ubuntu.com/tutorials/install-ubuntu-on-wsl2-on-windows-10#1-overview 
) tutorial. If you face some errors during installation, [HERE](https://appuals.com/wsl-register-distribution-error-0x80370102-on-windows-10/) are some troubleshooting tips. Another nice alternative is [Visual Studio Code](https://code.visualstudio.com/). 

This online cloud environment will mainly used for the scripting basic demonstration and the mini practice, we will use GitHub codespaces for the practice based on this GitHub, you can start codespaces using:


[![Open in Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?repo=SequAna-Ukon/SequAna_course&ref=2026)


If somehow, all previous were failed, we already give you access to SequAna's computational server: SequAna_Students. connections details can be found [HERE.](https://github.com/SequAna-Ukon/SequAna_course2024/wiki/Connecting-to-SequAna_Students'-computational-server:-sequana)

##  Bash scripting introduction

Most of the Bioinformatician and computational servers run a Linux distribution: Ubuntu.

[What is an operating system?](https://en.wikipedia.org/wiki/Operating_system)

[What is Unix?](https://en.wikipedia.org/wiki/Unix)

[What is Linux?](https://www.linux.com/what-is-linux/)

The vast majority of bioinformatic programs run on Linux, although many can also be run on Windows or on Mac OS X.

Mac OS X is Unix-based and therefore has many similarities to Linux distributions.
The terminal app on Mac OS X offers the user a command line interface (CLI; terminal) very similar to that of Linux distributions.

> **Exercise:** Play with the commands [HERE](https://github.com/SequAna-Ukon/SequAna_course/blob/main/docs/2026/SHELL.md) to get familiar with bash scripting.
Try to figure out the use of each bash command in the given example.
 

## Some key sequence data formats - fasta, fastq, fastq.gz, sam and bam

There are a few key formats that you should be familiar with in the realm of computational biology.

[What is a fasta file?](https://en.wikipedia.org/wiki/FASTA_format)

[What is a fastq file?](https://en.wikipedia.org/wiki/FASTQ_format)

[What are sam and bam files?](https://www.zymoresearch.com/blogs/blog/what-are-sam-and-bam-files#:~:text=SAM%20files%20are%20a%20type,the%20examples%20for%20this%20section.)

> **Exercise:** Go take a look at the directory ```CL_data```. How big is the data?

<details>
<summary>Hint</summary>

```
du -sh 
```
</details>

Now you know where the data is, you can either work directly with that data, or an easier way is to create a shortcut to that data in your directory. For this purpose, Linux has symbolic links.

[What is a symbolic link (symlink)?](https://www.futurelearn.com/info/courses/linux-for-bioinformatics/0/steps/201767#:~:text=A%20symlink%20is%20a%20symbolic,directory%20in%20any%20file%20system.)

> **Exercise**: Create a directory structure in your directory to hold the data. Create symlinks to populate the directories with symlinks to the sequencing file.

<details>
<summary>Hint</summary>

```
man ln
```
</details>

# Using package managers to install programs

## Installing software in your directory

We'll need some programs if we're going to do some work. One way to install programs on a Linux system is at the system level. This allows all users to access the programs. Many of the programs you've already used are installed at the systems level.

You can use the command ' which ' to see where a program is being executed from. E.g.:

```
$ which ls
/usr/bin/ls
```

While this might seem convenient, there are many reasons not to install programs at the system level not limited to:
- You must have root access to be able to install the programs
- It isn't easy to work with multiple versions of programs (i.e. v0.1.3 vs v0.1.4)

There are several ways to overcome the above issues. One is to download the source code for programs or pre-compiled programs and install these in a local directory. While this solves the problem of root access and the program will only be installed for your use, it still doesn't help us with managing multiple versions of programs. It can also be challenging to download the source code of some programs and get it to compile correctly often due to dependency issues. However, sometimes downloading a program and installing it yourself is the only option available to you.

## Packages manager

Let's meet another option for installing programs: [Conda](https://conda.io/projects/conda/en/latest/index.html) - a package manager that allows you to create multiple environments, often specific to a given project or analysis, that can have different packages and programs installed in them.

See [here](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html) for managing environments with conda. Conda can be installed in your home directory without root access (sudo access) and enables you to install programs locally.

Recently, another faster package manager has been developed named [mamba](https://mamba.readthedocs.io/en/latest/index.html). mamba, can be installed through [conda](https://anaconda.org/conda-forge/mamba) as well.   

> **Exercise:** Install [miniconda](https://www.anaconda.com/docs/getting-started/miniconda/install#quickstart-install-instructions) in your home directory. If you're not sure which options to select, ask! Once it's installed you'll need to start a new ssh session.

> **Exercise:** Try to use both mamba and conda, to determine their performance deferences.

Great! We now can create environments and install programs locally using the 'conda' or 'mamba' command.

> **Exercise**: Create a new environment called `qc_env` and in it install: 
> - [fastqc](https://anaconda.org/bioconda/fastqc)
>
> Verify that you can run fastqc

We will use this environment later on. As one of the first tasks we will need to undertake for our analysis is testing the quality of our generated sequencing data.
