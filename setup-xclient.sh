#!/bin/bash

XSERVER_NAME="$1"
X_DISPLAY=':0'
IS_APT_GET=`command -v apt-get`
IS_YUM=`command -v yum`
IS_XAUTH=`command -v xauth`

if [ -z "$XSERVER_NAME" ]; then
  echo "[ERROR] Please provide the container name of the xserver in the 1st argument."
  exit 1
fi

if [ -z "$IS_XAUTH" ]; then
  if [ -n "$IS_APT_GET" ]; then
    echo "[INFO] Use 'apt-get install' to install 'xauth' package. Now it is installing..."
    apt-get update && apt-get install -y --no-install-recommends xauth
  elif [ -n "$IS_YUM" ]; then
    echo "[INFO] Use 'yum install' to install 'xauth' package. Now it is installing..."
    yum update && yum install -y xauth
  else
    echo '[ERROR] This script only supports Ubuntu or Centos.'
    echo "Please install 'xauth' based on your system's install package command."
    exit 1
  fi
fi

if [ "$?" != "0" ]; then
  echo "[ERROR] Failed to install xauth."
  exit 1
fi

echo "export DISPLAY=${XSERVER_NAME}${X_DISPLAY}" >> ${HOME}/.bashrc

if [ ! -f ${HOME}/.Xauthority ]; then
  touch ${HOME}/.Xauthority
fi

xauth merge /Xauthority/xserver.xauth
if [ "$?" == "0" ]; then
  echo "[SUCCESS] mcookie setting via xauth is completed. Please run 'source \${HOME}/.bashrc' to activate it."
else
  echo "[ERROR] mcookie setting via xauth is failed." 
fi
