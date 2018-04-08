#!/bin/bash
# Script to build all components from scratch, using the maximum available CPU power

# Go into the directory where this bash script is contained.
cd `dirname $0`

# Compile code.
mkdir -p build
cd build
cmake ..
make -j `nproc` $*

if [ $? -eq 0 ]
then
  echo .
  echo .
  echo .
  echo Build process completed!
  echo .
  echo .
  echo .
else
  echo .
  echo .
  echo .
  echo Error!
  echo .
  echo .
  echo .
fi

