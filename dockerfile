FROM ubuntu:latest
MAINTAINER Arthur Gilly "ag15@sanger.ac.uk"

RUN apt-get update

RUN apt-get install -y apt-utils python python-pip python3 nano wget iputils-ping git yum gcc gfortran libc6 libc-bin libc-dev-bin make libblas-dev liblapack-dev libatlas-base-dev curl zlib1g zlib1g-dev libbz2-1.0 libbz2-dev libbz2-ocaml libbz2-ocaml-dev liblzma-dev lzma lzma-dev

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
RUN wget http://www.well.ox.ac.uk/~gav/resources/snptest_v2.5.1_linux_x86_64_dynamic.tgz
RUN tar -xvzf snptest_v2.5.1_linux_x86_64_dynamic.tgz
RUN cp /snptest_v2.5.1_linux_x86_64_dynamic/snptest_v2.5.1 /usr/bin
RUN rm -r /snptest_v2.5.1_linux_x86_64_dynamic /snptest_v2.5.1_linux_x86_64_dynamic.tgz
RUN git clone https://github.com/xianyi/OpenBLAS.git
WORKDIR OpenBLAS
ADD openblas.conf /etc/ld.so.conf.d/openblas.conf
RUN make DYNAMIC_ARCH=1 NO_AFFINITY=1 NUM_THREADS=32
RUN make install
RUN ldconfig
WORKDIR /
RUN git clone https://github.com/genetics-statistics/GEMMA.git
WORKDIR /GEMMA
RUN apt-get install -y libeigen3-dev libgsl0-dev
RUN ln -s /opt/OpenBLAS/lib/libopenblas.so /usr/lib/libopenblas.so
RUN sed -i 's/\/usr\/local\/opt\/openblas\/include/\/opt\/OpenBLAS\/include/' Makefile
RUN make
RUN cp bin/gemma /usr/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y r-base 
WORKDIR /
RUN wget http://csg.sph.umich.edu/abecasis/metal/download/generic-metal-2011-03-25.tar.gz
RUN tar -xvzf generic-metal-2011-03-25.tar.gz
WORKDIR /generic-metal
RUN make all
RUN make install
WORKDIR /
RUN wget https://data.broadinstitute.org/alkesgroup/BOLT-LMM/downloads/BOLT-LMM_v2.3.2.tar.gz
RUN tar -xvzf BOLT-LMM_v2.3.2.tar.gz
ENV PATH="/BOLT-LMM_v2.3.2:${PATH}"
RUN rm -r BOLT-LMM_v2.3.2.tar.gz generic-metal-2011-03-25.tar.gz /generic-metal
WORKDIR /
RUN wget https://www.well.ox.ac.uk/~gav/resources/qctool_v2.0.1-Ubuntu16.04-x86_64.tgz
RUN tar -xvzf qctool_v2.0.1-Ubuntu16.04-x86_64.tgz
RUN cp qctool_v2.0.1-Ubuntu16.04-x86_64/qctool /usr/bin/qctool2
RUN wget https://www.well.ox.ac.uk/~gav/resources/archive/qctool_v1.5-linux-x86_64-static.tgz
RUN tar -xvzf qctool_v1.5-linux-x86_64-static.tgz
RUN cp qctool_v1.5-linux-x86_64/qctool /usr/bin/qctool1
RUN rm -r qctool*
RUN wget https://homepages.uni-regensburg.de/~wit59712/easyqc/EasyQC_9.2.tar.gz
RUN apt-get install -y libcairo2-dev libxt-dev
RUN Rscript -e "install.packages(c('Cairo', 'plotrix', 'data.table'))"
RUN Rscript -e "install.packages('EasyQC_9.2.tar.gz')"
WORKDIR /home
