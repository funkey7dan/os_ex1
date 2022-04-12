#!/bin/bash
#Daniel Bronfman ***REMOVED***

shopt -s globstar # enable shell option for wildcard folders matching

### clean all the out files ### 

for file in "$1"*.*; do
if [[ $file == *.out ]]
then
    rm $file 
fi
    done

if [ "$3" = "-r" ] # if recursive flag passed
then
for file in "$1"**/*; do
    if [[ $file == *.out ]]
then
    rm $file 
fi
    done
fi

### compile all the c files section ###

for file in "$1"*.c; do
    if [[ $file == *.c ]] && grep -q -i "$2" <<< "$file"
    then
    gcc -w $file -o ${file%%.c}.out #strip the file extension
    fi
    done
   
if [ "$3" = "-r" ] # if recursive flag passed
then
for file in "$1"**/*.c; do
    if [[ $file == *.c ]] && grep -q -i "$2" <<< "$file"
    then
    gcc -w $file -o ${file%%.c}.out #compile the c file and strip the file extension for output
    fi
    done
fi