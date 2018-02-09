FROM xpra:latest

MAINTAINER github/emibcn

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y \
       iperf \
       traceroute \
       openjdk-8-jre && \
    apt-get -y clean autoclean autoremove

ENV URL https://fw-download.ubnt.com/data/airControl/642b-unix64-v2.1.0-rc-e3084447f47948b2ac272974aaad6b91.bin

RUN \
   wget -O /tmp/aircontrol.bin "$URL" && \
   chmod +x /tmp/aircontrol.bin && \
   echo -e '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n1\n\n2\nn' | /tmp/aircontrol.bin

ENV USER developer

RUN chmod +x /opt/Ubiquiti/AirControl2/airControl2Client && \
    mkdir -p /home/${USER}/.AirControl2 && \
    chown ${USER}:${USER} /home/${USER}/.AirControl2

VOLUME ["/home/${USER}/"]
