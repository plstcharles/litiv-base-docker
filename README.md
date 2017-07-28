LITIV Docker Base Image Builder
===============================

[![License](https://img.shields.io/badge/license-Apache%202-green.svg)](https://tldrlegal.com/license/apache-license-2.0-(apache-2.0))
[![Build Status](https://travis-ci.org/plstcharles/litiv-base-docker.svg?branch=master)](https://travis-ci.org/plstcharles/litiv-base-docker)
[![Docker Pulls](https://img.shields.io/docker/pulls/plstcharles/litiv-base.svg)](https://hub.docker.com/r/plstcharles/litiv-base)

This repository serves to build a docker image for all LITIV framework dependencies.

Contents:
* libx264 (latest snapshot, statically compiled with pic)
* ffmpeg (latest snapshot, gpl/nonfree w/ x264 & nasm support)
* OpenCV (v3.2.0 snapshot by default, w/ contrib & ffmpeg support)
* OpenGM (latest fork snapshot, w/ external libs support)

See the original repo at https://github.com/plstcharles/litiv for more information.
