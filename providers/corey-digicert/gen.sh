#!/bin/bash

DIR=`realpath "$1"`

docker run --rm -v $DIR:/artifacts ghcr.io/cbonnell/snakefoot python3 generator.py /artifacts
