#!/bin/bash

PROJ_NAME='xserver'
DOCKER_REPO="weichuntsai\\/${PROJ_NAME}"
DOCKER_VER='1.1'

PTN_PROJ_NAME="s/\\\$PROJ_NAME\\\$/${PROJ_NAME}/g"
PTN_DOCKER_REPO="s/\\\$DOCKER_REPO\\\$/${DOCKER_REPO}/g"
PTN_DOCKER_VER="s/\\\$DOCKER_VER\\\$/${DOCKER_VER}/g"

SRC='tpl-readme.md'
OUTPUT='README.md'

sed -r -e "$PTN_PROJ_NAME" -e "$PTN_DOCKER_REPO" -e "$PTN_DOCKER_VER" $SRC > $OUTPUT
