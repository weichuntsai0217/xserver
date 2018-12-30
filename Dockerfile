# [IMPORTANT] Use "debian:jessie" as base image
#   It is super important to use "debian:jessie" as base image
#   to make remote xclients connection to xserver successful.
#   If you change it into "ubuntu:16.04",
#   remote x clients connection to xserver would fail!
FROM debian:jessie

# "gtk2-engines-pixbuf" is to make "icewm" icon display OK.
RUN apt-get update && apt-get install -y --no-install-recommends xvfb xauth x11vnc x11-utils x11-xserver-utils gtk2-engines-pixbuf icewm

# In the future, if you have more fancy requirements, you can consider install full "xorg" package as follows:
# RUN apt-get update && apt-get install -y --no-install-recommends xvfb xauth x11vnc x11-utils x11-xserver-utils xorg icewm

# After running "run-xserver.sh", we would put xserver mcookie for xauth in /Xauthority to share with remote xclients.
# Remote xclients could use this mcookie in its /Xauthority as authentication to connect to our xserver.
RUN mkdir /Xauthority
VOLUME /Xauthority

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV DISPLAY :0
ENV HOME /root
RUN echo "export DISPLAY=:0" >> ${HOME}/.bashrc

COPY run-xserver.sh /run-xserver.sh
ENTRYPOINT ["/run-xserver.sh"]
