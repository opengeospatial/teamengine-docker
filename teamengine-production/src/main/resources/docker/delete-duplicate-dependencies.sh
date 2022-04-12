#!/bin/bash
filename='list-of-duplicate-dependencies.txt'

while read p; do
    echo Deleting "$p"
    rm -rfv "$p" | wc -l
done < "$filename"
