#!/bin/bash
PKG_DIR='build_output/python'
LIB_DIR='build_output/lib'
IMAGE_NAME='nonbeing/lambda-python38-mysqlclient'

sudo rm -rf ${PKG_DIR} ${LIB_DIR}
mkdir -p ${PKG_DIR} && mkdir -p ${LIB_DIR}

# note: Build a docker image closely matching the AWS Lambda environment
# set the docker image name above (IMAGE_NAME variable)
docker build -t ${IMAGE_NAME} .

if [ $? -eq 0 ]; then
    docker run --rm -v $(pwd):/foo -w /foo ${IMAGE_NAME} /foo/pip_and_copy.sh ${PKG_DIR} ${LIB_DIR}


    cd build_output
    zip -r layer.zip .
else
    echo "[ERROR] Docker build failed! Not building `layer.zip` file. Abort."
fi