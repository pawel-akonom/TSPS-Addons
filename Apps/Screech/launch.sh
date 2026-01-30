#!/bin/bash
progdir=$(dirname "$0")
cd $progdir
./screech &> debug.txt
