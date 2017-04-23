#!/usr/bin/env bash

if [ -z $1 ]; then
    echo "usage: $0 <xml_file>"
    exit 1;
fi

mkdir -p output

./init_db.py && ./xml_parse.py $1

