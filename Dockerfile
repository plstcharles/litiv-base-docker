
# This file is part of the LITIV framework; visit the original repository at
# https://github.com/plstcharles/litiv for more information.
#
# Copyright 2016 Pierre-Luc St-Charles; pierre-luc.st-charles<at>polymtl.ca
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM centos:7
MAINTAINER Pierre-Luc St-Charles <pierre-luc.st-charles@polymtl.ca>
LABEL Description="Contains all LITIV framework dependencies (C++11 compat build)"

ENV opencvtag=3.1.0
ENV nbthreads=4

RUN yum update -y && yum install -y \
    gcc \
    gcc-c++ \
    make \
    gettext \
    patch \
    patchutils \
    autoconf \
    automake \
    bzip2 \
    cmake \
    git \
    pkgconfig \
    zlib-devel \
    texinfo \
    wget \
    curl \
    unzip \
    python \
    tbb \
    tbb-devel \
    libtool \
    libjpeg \
    libpng \
    eigen3 \
    && yum clean all

WORKDIR /
RUN git clone --depth 1 git://github.com/yasm/yasm.git && \
    cd /yasm && autoreconf -fiv && ./configure && make install && make distclean

WORKDIR /
RUN wget http://download.videolan.org/pub/x264/snapshots/last_x264.tar.bz2 && \
    tar xjvf last_x264.tar.bz2 && rm last_x264.tar.bz2 && mv x264-snapshot* x264 && cd x264 && \
    ./configure --enable-shared && \
    make -j${nbthreads} && make install && make distclean

WORKDIR /
RUN wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && \
    tar xjvf ffmpeg-snapshot.tar.bz2 && rm ffmpeg-snapshot.tar.bz2 && cd ffmpeg && \
    ./configure \
        --enable-shared \
        --disable-static \
        --enable-gpl \
        --enable-nonfree \
        --enable-libx264 \
        --enable-version3 \
        --enable-runtime-cpudetect && \
    make -j${nbthreads} && make install && make distclean

RUN git clone -b ${opencvtag} --progress --verbose --single-branch https://github.com/opencv/opencv.git /opencv && git clone -b ${opencvtag} --progress --verbose --single-branch https://github.com/opencv/opencv_contrib.git /opencv_contrib
WORKDIR /opencv/build
RUN sed -i -e 's/libavformat\.a/libavformat.so/g' \
        -e 's/libavutil\.a/libavutil.so/g' \
        -e 's/libswscale\.a/libswscale.so/g' \
        -e 's/libavresample\.a/libavresample.so/g' \
        -e 's/libavcodec\.a/libavcodec.so/g' \
        ../cmake/OpenCVFindLibsVideo.cmake && \
    cmake \
        -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules \
        -D BUILD_DOCS=OFF \
        -D BUILD_TESTS=OFF \
        -D BUILD_PERF_TESTS=OFF \
        -D WITH_OPENMP=ON \
        -D WITH_FFMPEG=ON \
        .. && \
    make -j${nbthreads} install && rm -r /opencv/build

RUN git clone -b master --progress --verbose --single-branch https://github.com/plstcharles/opengm.git /opengm
WORKDIR /opengm/build
RUN cmake \
        -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D BUILD_EXAMPLES=OFF \
        -D BUILD_TESTING=OFF \
        -D BUILD_TUTORIALS=OFF \
        -D INSTALL_EXTERNAL_LIB=ON \
        -D WITH_GCO=ON \
        -D WITH_MAXFLOW=ON \
        -D WITH_OPENMP=ON \
        -D WITH_QPBO=ON \
        -D WITH_TRWS=ON \
        .. && \
    make externalLibs && cmake .. && make -j${nbthreads} install && rm -r /opengm/build

RUN ldconfig
WORKDIR /
CMD ["/bin/bash"]
