FROM ubuntu:xenial

RUN export DEBIAN_FRONTEND=noninteractive LANG
RUN apt update

# set locale
RUN apt install -y --no-install-recommends apt-utils locales

RUN echo en_US.UTF-8 UTF-8 > /etc/locale.gen
RUN locale-gen
RUN update-locale LANG=en_US.UTF-8
RUN export LANG=en_US.UTF-8

RUN apt install -y --no-install-recommends supervisor
RUN mkdir -p /var/log/supervisor /etc/supervisor/conf.d

RUN apt install -y --no-install-recommends wget sudo
RUN apt install -y --no-install-recommends xvfb xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic
RUN apt install -y --no-install-recommends iproute2

RUN export LICENSE_ACCEPTED=yes
RUN wget -O - --no-check-certificate 'https://raw.githubusercontent.com/tkmnet/Tools/master/install-oracle-jdk.sh' | sh

RUN apt install -y --no-install-recommends openssh-server
RUN mkdir /root/.ssh
RUN chmod 700 /root/.ssh
WORKDIR /root/.ssh
RUN ssh-keygen -q -f id_rsa -N ""
RUN cp id_rsa.pub authorized_keys
RUN mkdir -p /var/run/sshd

COPY supervisord.conf /etc/supervisor/supervisord.conf

RUN apt install -y --no-install-recommends expect
RUN useradd user
RUN echo 'user	ALL=(ALL:ALL) ALL' >> /etc/sudoers

RUN apt-get upgrade -y && apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* 

COPY start.sh /root/start.sh
RUN chmod a+x /root/start.sh

WORKDIR /root
ENTRYPOINT "/root/start.sh"
