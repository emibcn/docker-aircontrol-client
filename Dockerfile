FROM xpra:latest

MAINTAINER github/emibcn

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y \
       iperf \
       traceroute \
       openjdk-8-jre && \
    apt-get -y clean autoclean autoremove

COPY aircontrol.bin /tmp/

RUN echo -e '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n1\n\n2\nn' | /tmp/aircontrol.bin

ENV USER developer

RUN chmod +x /opt/Ubiquiti/AirControl2/airControl2Client && \
    mkdir -p /home/${USER}/.AirControl2 && \
    chown ${USER}:${USER} /home/${USER}/.AirControl2

VOLUME ["/home/${USER}/"]
