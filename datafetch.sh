#!/bin/bash

source "$(dirname $BASH_SOURCE)/uri_parse.sh"

#ARGS src (http,ftp,s3) md5

SRC=$1
DST=$2
EXPECTED_MD5=$3

EXISTS=$(aws s3 ls $DST)
if [ -z "$EXISTS" ]; then
    echo "$DST not found"
else
    echo "$DST already exists"
    exit 0
fi

URI_PATH=$(parse_path $SRC)

RES_NAME=$(basename $URI_PATH)

rm -rf download_box
mkdir download_box
cd download_box

s3_download() {
    local SRC=$1
    aws s3 sync $SRC ./$RES_NAME
}

s3_pipe(){
    echo "Pipe"

    local PIPE_DST=$DST/$RES_NAME
    #Replace // if any
    PIPE_DST=${PIPE_DST/\/\/$RES_NAME/\/$RES_NAME}

    aws s3 sync $SRC $PIPE_DST
}

wget_download() {
    local SRC=$1
    wget $SRC
}

check_md5() {
    local ACTUAL_MD5=($(md5sum ./$RES_NAME))
    if [ "$ACTUAL_MD5" != "$EXPECTED_MD5" ]; then
        echo "MD5 Validation failed"
        exit 1
    else
        echo "MD5 Validation OK"
    fi
}

s3_upload() {
    local DST=$1
    aws s3 sync ./ $DST $AWS_DST_REGION
}

echo $SRC
if [[ $SRC == s3* ]]; then
    if [ -z "$EXPECTED_MD5" ]; then
        s3_pipe $SRC $DST
        exit 0
    else
        s3_download $SRC
    fi
else
    wget_download $SRC
fi

if [ -n "$EXPECTED_MD5" ] && [ -f ./$RES_NAME ]; then
    check_md5 $EXPECTED_MD5
fi

s3_upload $DST
