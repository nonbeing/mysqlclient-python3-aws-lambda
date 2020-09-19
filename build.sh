#!/bin/bash
PKG_DIR='build_output/python'
LIB_DIR='build_output/lib'

# set the docker image name here (optional)
IMAGE_NAME='nonbeing/lambda-python38-mysqlclient'

sudo rm -rf build_output
mkdir -p ${PKG_DIR} && mkdir -p ${LIB_DIR}

# build a docker image closely matching the AWS Lambda environment, with mysql-devel installed
docker build -t ${IMAGE_NAME} .

if [ $? -eq 0 ]; then
    # actually build the layer zip now:
    docker run --rm -v $(pwd):/foo -w /foo ${IMAGE_NAME} /foo/pip_and_copy.sh ${PKG_DIR} ${LIB_DIR}
    cd build_output
    zip -r layer.zip .
else
    echo "[ERROR] Docker build failed! Not building `layer.zip` file. Abort."
fi
