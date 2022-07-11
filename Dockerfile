FROM ubuntu:20.04
MAINTAINER Enrico Moiso <moiso.enrico@gmail.com>

#
# Debian/Ubuntu oddities
#
ENV DEBIAN_FRONTEND noninteractive

#
# Update system and install base packages
#
RUN apt-get update && apt-get install -q -y \
 wget \
 build-essential

#
# INSTALL R From standard ubuntu repository
#
RUN apt-get install -y r-base-core r-base-dev r-recommended
RUN echo "q()" | R --no-save

#
# Setup CRAN
#
RUN apt-get install -y r-cran-*
#RUN echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.mirror.garr.it/mirrors/CRAN/'; options(repos = r);" > ~/.Rprofile
RUN echo "r <- getOption('repos'); r['CRAN'] <- 'https://cloud.r-project.org/'; options(repos = r);" > ~/.Rprofile

#
# Install R Packages
#
RUN Rscript -e "install.packages('Matrix')"
RUN Rscript -e "install.packages('ggpubr')"
RUN Rscript -e "install.packages('pheatmap')"
RUN Rscript -e "install.packages('ggalluvial')"
RUN Rscript -e "install.packages('data.table')"
RUN Rscript -e "install.packages('RColorBrewer')"
RUN Rscript -e "install.packages('ggplot2')"
RUN Rscript -e "install.packages('reshape2')"
RUN Rscript -e "install.packages('gridExtra')"
RUN Rscript -e "install.packages('grDevices')"
RUN Rscript -e "install.packages('parallel')"
RUN Rscript -e "install.packages('umap')"
RUN Rscript -e "install.packages('lsa')"
RUN Rscript -e "install.packages('scales')"
RUN Rscript -e "install.packages('viridis')"
RUN Rscript -e 'requireNamespace("BiocManager"); BiocManager::install("limma")' 

#
# Install python
#

RUN apt-get update && apt-get install -y \
	libopencv-dev \
	python3-pip \
	python3-opencv 
RUN apt-get clean 
RUN rm -rf /var/lib/apt/lists/*

#
# Install python Packages
#
RUN pip3 install keras 
RUN pip3 install numpy 
RUN pip3 install scikit-learn 
RUN pip3 install tensorflow

#
# Install STAR
#
ENV star_version 2.7.10a
WORKDIR /docker_main
ADD https://github.com/alexdobin/STAR/archive/2.7.10a.tar.gz /usr/bin/
RUN tar -xzf /usr/bin/${star_version}.tar.gz -C /usr/bin/
RUN cp /usr/bin/STAR-${star_version}/bin/Linux_x86_64/* /usr/local/bin
RUN cd /docker_main / && \
   rm -rf 2.7.10a.tar.gz && \
   apt-get autoremove -y && \
   apt-get autoclean -y  && \
   apt-get clean

#
# Install RSEM
#
RUN apt-get update
RUN apt-get -y install git cmake automake 
WORKDIR /usr/local/
RUN pwd
RUN git clone https://github.com/deweylab/RSEM.git
WORKDIR /usr/local/RSEM
RUN pwd
RUN git checkout v1.2.28
RUN make ; exit 0 #!careful!
RUN make ebseq

#
#
#

RUN cd /docker_main
RUN export TERM=xterm

WORKDIR /

#
# Script launch
#
#ENTRYPOINT ["~/"]


