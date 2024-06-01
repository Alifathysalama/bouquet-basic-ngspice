#!/bin/bash

set -ex

# Setup Sources and Bootstrap APT

echo "[INFO] Updating, upgrading and installing packages with APT"

apt -y update
apt -y upgrade
apt -y install \
	ant \
	autoconf \
	automake \
	autotools-dev \
	bc \
	binutils-gold \
	bison \
	build-essential \
	bzip2 \
	ca-certificates \
	cmake \
	csh \
	curl \
	doxygen \
	flex \
	g++ \
	gawk \
	gcc \
	gdb \
	gettext \
	ghostscript \
	git \
	gnupg2 \
	gperf \
	gpg \
	help2man \
	libblas-dev \
	libbz2-dev \
	libc6-dev \
	libcairo2-dev \
	libcurl4-openssl-dev \
	libeigen3-dev \
	libffi-dev \
	libfftw3-dev \
	libgcc-11-dev \
	libgettextpo-dev \
	libgit2-dev \
	libglu1-mesa-dev \
	libgmp-dev \
	libgomp1 \
	libjpeg-dev \
	libjudy-dev \
	liblapack-dev \
	liblemon-dev \
	liblzma-dev \
	libncurses-dev \
	libopenmpi-dev \
	libpcre2-dev \
	libpcre3-dev \
	libre2-dev \
	libreadline-dev \
	libssl-dev \
	libstdc++-11-dev \
	libsuitesparse-dev \
	libtcl \
	libtool \
	libx11-dev \
	libx11-xcb-dev \
	libxaw7-dev \
	libxcb1-dev \
	libxext-dev \
	libxft-dev \
	libxml2-dev \
	libxpm-dev \
	libxrender-dev \
	libxslt-dev \
	libyaml-dev \
	libz-dev \
	libz3-dev \
	libzip-dev \
	libzstd-dev \
	make \
	openmpi-bin \
	openssl \
	patch \
	patchutils \
	pciutils \
	pkg-config \
	strace \
	tcl \
	tcl-dev \
	tcl-tclreadline \
	tcllib \
	tclsh \
	texinfo \
	time \
	tk-dev \
	tzdata \
	unzip \
	wget \
	zip \
	zlib1g-dev \
	python3-numpy \
	python3-pip



update-alternatives --install /usr/bin/python python /usr/bin/python3 0	

# cd /usr/lib/llvm-15/bin
# for f in *; do rm -f /usr/bin/"$f"; \
#     ln -s ../lib/llvm-15/bin/"$f" /usr/bin/"$f"
# done

echo "[INFO] Cleaning up caches"
rm -rf /tmp/*
apt -y autoremove --purge
apt -y clean
