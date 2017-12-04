FROM ubuntu:latest
MAINTAINER Arthur Gilly "ag15@sanger.ac.uk"

RUN apt-get update

RUN apt-get install -y apt-utils python python-pip python3 nano wget iputils-ping git yum gcc gfortran libc6 libc-bin libc-dev-bin make libblas-dev liblapack-dev libatlas-base-dev libatlas-dev curl zlib1g zlib1g-dev libbz2-1.0 libbz2-dev libbz2-ocaml libbz2-ocaml-dev liblzma-dev lzma lzma-dev

#RUN wget https://www.cog-genomics.org/static/bin/plink171114/plink_linux_x86_64.zip
#RUN apt-get install -y git yum gcc gfortran libc6 libc-bin libc-dev-bin make libblas-dev liblapack-dev libatlas-base-dev libatlas-dev curl

RUN git clone https://github.com/chrchang/plink-ng.git
WORKDIR /plink-ng/1.9
RUN ./plink_first_compile
RUN cp plink /usr/bin
WORKDIR /
RUN rm -r /plink-ng
#RUN apt-get install -y zlib1g zlib1g-dev
#RUN apt-get install -y libbz2-1.0 libbz2-dev libbz2-ocaml libbz2-ocaml-dev 
#RUN apt-get install -y lzma lzma-dev
RUN git clone git://github.com/samtools/htslib.git
RUN git clone git://github.com/samtools/bcftools.git
RUN git clone https://github.com/samtools/samtools.git
WORKDIR /bcftools
RUN make
WORKDIR /htslib
RUN make tabix
WORKDIR /samtools
RUN make samtools
RUN cp /samtools/samtools /htslib/tabix /bcftools/bcftools /usr/bin
RUN rm -r /bcftools /htslib /samtools
WORKDIR /
RUN wget http://www.well.ox.ac.uk/~gav/resources/snptest_v2.5.2_linux_x86_64_dynamic.tgz
RUN tar -xvzf snptest_v2.5.2_linux_x86_64_dynamic.tgz
RUN cp /snptest_v2.5.2_linux_x86_64_dynamic/snptest_v2.5.2 /usr/bin
RUN rm -r /snptest_v2.5.2_linux_x86_64_dynamic /snptest_v2.5.2_linux_x86_64_dynamic.tgz
RUN git clone https://github.com/genetics-statistics/GEMMA.git
WORKDIR /GEMMA
RUN apt-get install -y libeigen3-dev libgsl0-dev
RUN make
RUN cp bin/gemma /usr/bin
RUN apt-get install -y r-base 
WORKDIR /home
