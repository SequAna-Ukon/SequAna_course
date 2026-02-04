© 2026 Abdoallah Sharaf

# Working with Docker images
- Computational workflows are rarely composed of a single script or tool. More often, they depend on dozens of software components or libraries.Installing and maintaining such dependencies is a challenging task and a common source of irreproducibility in scientific applications. To overcome these issues, you can use a container technology that enables software dependencies. These container images can be easily deployed in any platform that supports the container runtime. Containers can be executed in an isolated manner from the hosting system. Having its own copy of the file system, processing space, and memory management. Docker is a handy management tool to build, run and share container images. These container images can be uploaded and published in a centralized repository known as [Docker Hub](https://hub.docker.com/), or hosted by other parties, such as [Quay](https://quay.io/). Good tutorial materials are available [here](https://training.nextflow.io/basic_training/containers/). but i will just demonstrate few examples on the [course Gitpod](http://gitpod.io/#https://github.com/SequAna-Ukon/SequAna_course.git).

- Run the publicly available ```hello-world``` container

````bash
docker run hello-world  
````
- Let's try to pull and work with one of the publicly available containers with ```fastqc``` tool

````bash
docker pull staphb/fastqc
````

- We can check if a container has been pulled using the images command.
````bash
docker images
````
- Run a container
    - images can be run directly
    ````bash
    docker run staphb/fastqc fastqc -h
    ````
   - Also, images can be run interax=crtively
   ```bash
    docker run -it staphb/fastqc
   ````
   - in the interactive mode you should consider mounting the current directory 
   ````bash
   docker run -v $PWD:$PWD -w $PWD -it staphb/fastqc
   ````
- Build your docker image

Docker images are created by using a so-called Dockerfile,a simple text file containing a list of commands to assemble and configure the image with the software packages required. For example, a Dockerfile to create a container with curl installed could be as simple as this:

````
FROM ubuntu:latest

LABEL image.author.name "Abdo"
LABEL image.author.email "your@email.here"

RUN apt-get update && apt-get install -y fastqc

````
- Once your Dockerfile is ready, you can build the image using the build command.

````bash 
docker build -t my-image .
````
> **Exercise:** Pull and run interactively  he publicly available containers with ```trimmomatic``` software
