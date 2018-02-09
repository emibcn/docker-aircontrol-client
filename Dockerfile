FROM debian:latest

MAINTAINER github/emibcn

ENV DEBIAN_FRONTEND noninteractive

RUN \
   apt-get update && \
   apt-get install -y \
      sudo \
      openssh-server \
      xpra \
      wget \
      iperf \
      traceroute \
      openjdk-8-jre && \
   apt-get -y clean autoclean autoremove


# Create user and its home dir
ENV USER developer
ENV MYHOME /home/${USER}


# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p ${MYHOME}/.ssh && \
    echo "${USER}:x:${uid}:${gid}:Developer,,,:${MYHOME}:/bin/bash" >> /etc/passwd && \
    echo "${USER}:*:17448:0:99999:7:::"  >> /etc/shadow && \
    echo "${USER}:x:${uid}:" >> /etc/group && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER} && \
    chmod 0440 /etc/sudoers.d/${USER} 


# Copy RSA pub key
COPY ./id_rsa.pub ${MYHOME}/.ssh/authorized_keys


# Prepare SSH server
RUN chmod -R go-rwx ${MYHOME} && \
    chown -R ${USER}:${USER} ${MYHOME} && \
    mkdir -p /var/run/sshd && \
    sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && \
    touch /root/.Xauthority


# Download and install AirControl2 client
ENV URL https://fw-download.ubnt.com/data/airControl/642b-unix64-v2.1.0-rc-e3084447f47948b2ac272974aaad6b91.bin
RUN \
   wget -O /tmp/aircontrol.bin "$URL" && \
   chmod +x /tmp/aircontrol.bin && \
   echo -e '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n1\n\n2\nn' | /tmp/aircontrol.bin


# Prepare volume's persistent data
RUN chmod +x /opt/Ubiquiti/AirControl2/airControl2Client && \
    mkdir -p /home/${USER}/.AirControl2 && \
    chown ${USER}:${USER} /home/${USER}/.AirControl2


# Persistent data
VOLUME ["/home/${USER}/"]


# No detach, log to stdout
CMD ["/usr/sbin/sshd", "-D", "-e", "-d"]

