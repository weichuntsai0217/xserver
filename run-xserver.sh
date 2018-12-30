#!/bin/bash
# Custom values of VNC_PASSWORD, DISPLAY, DISABLE_VNC, DISABLE_WM, SCREEN_SIZE, SCREEN_DPI are all from environment variables.

if [ -z "$DISPLAY" ]; then
  DISPLAY=':0'
  export DISPLAY=${DISPLAY} # This line is for "icewm"
fi

if [ "$DISABLE_VNC" != 'true' ] && [ -z "$VNC_PASSWORD" ]; then
  echo -e '[ERROR] No password for VNC connection is set.\nDid you forget to add -e VNC_PASSWORD=... ?'
  exit 1
fi

if [ -z "$SCREEN_SIZE" ]; then
  SCREEN_SIZE='1200x675x24'
fi

if [ -z "$SCREEN_DPI" ]; then
  SCREEN_DPI='75'
fi

# first we need our security cookie and add it to user's .Xauthority
PTN="s/^/add $DISPLAY MIT-MAGIC-COOKIE-1 /"
mcookie | sed -e "$PTN" | xauth -q

# now place the security cookie with FamilyWild on volume so client can use it
# see http://stackoverflow.com/25280523 for details on the following command
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f /Xauthority/xserver.xauth nmerge -

# now boot X-Server, tell it to our cookie and give it sometime to start up
Xvfb $DISPLAY -auth ${HOME}/.Xauthority -dpi $SCREEN_DPI -screen ${DISPLAY:1:1} $SCREEN_SIZE > /dev/null &
sleep 3


# finally we can run the VNC-Server based on our just started X-Server
if [ "$DISABLE_VNC" != 'true' ]; then
  if [ "$DISABLE_WM" != 'true' ]; then
    # start a window manager - icewm
    icewm &
    sleep 3
  fi

  # start a vnc server
  x11vnc -forever -passwd $VNC_PASSWORD -display $DISPLAY -rfbport 5900 2> /dev/null
fi
