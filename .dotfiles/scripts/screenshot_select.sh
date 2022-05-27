#!/bin/bash

datestr=$(date +"%y%m%d-%H%M%S")
filename=screenshot-$datestr.png

mkdir -p ~/Pictures/Screenshots

scrot -sf ~/Pictures/Screenshots/$filename
