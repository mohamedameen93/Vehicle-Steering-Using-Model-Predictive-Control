#!/bin/bash
# Script to clean the tree from all compiled files.

cd `dirname $0`
rm -rf build

if [ $? -eq 0 ]
then
  echo .
  echo .
  echo .
  echo Cleaned up the project!
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
