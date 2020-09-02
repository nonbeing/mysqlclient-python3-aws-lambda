#!/bin/bash
# this script is used in and by build.sh
PKG_DIR=$1
LIB_DIR=$2

# get the cchardet wheel
# url source: https://pypi.org/project/cchardet/#modal-close
curl -vkL -O https://files.pythonhosted.org/packages/88/f3/0db5b64fecac9d77302604eb8404807755e8882d3d31bbf33d037861e642/cchardet-2.1.6-cp38-cp38-manylinux2010_x86_64.whl

pip install cchardet-2.1.6-cp38-cp38-manylinux2010_x86_64.whl -t ${PKG_DIR};
