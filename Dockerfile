FROM ubuntu:xenial

RUN export DEBIAN_FRONTEND=noninteractive LANG
RUN apt update

# set locale
RUN apt install -y --no-install-recommends apt-utils locales

RUN echo en_US.UTF-8 UTF-8 > /etc/locale.gen
RUN locale-gen
RUN update-locale LANG=en_US.UTF-8
RUN export LANG=en_US.UTF-8

# apt package
# need for git
RUN apt install -y --no-install-recommends git
RUN apt install -y --no-install-recommends ca-certificates openssl

RUN apt install -y --no-install-recommends supervisor
RUN mkdir -p /var/log/supervisor /etc/supervisor/conf.d

RUN apt install -y --no-install-recommends wget sudo
RUN apt install -y --no-install-recommends xvfb xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic
RUN apt install -y --no-install-recommends ant

RUN export LICENSE_ACCEPTED=yes
RUN wget -O - --no-check-certificate 'https://raw.githubusercontent.com/tkmnet/Tools/master/install-oracle-jdk.sh' | sh

WORKDIR /root
RUN git clone 'https://github.com/tkmnet/rrsenv.git'
WORKDIR /root/rrsenv
RUN sh init.sh
RUN git clone 'https://github.com/tkmnet/rcrs-server.git'
RUN rm -rf roborescue
RUN mv rcrs-server roborescue
WORKDIR /root/rrsenv/roborescue
RUN env LANG=en_US.UTF-8 ant -lib ./build-tools complete-build
RUN apt install -y --no-install-recommends build-essential autoconf libtool pkg-config openssh-client openssh-server
RUN cpan -i Net::OpenSSH
RUN cpan -i IO::Pty
RUN cpan -i JSON

RUN apt install -y --no-install-recommends openssh-server
RUN mkdir /root/.ssh
RUN chmod 700 /root/.ssh
WORKDIR /root/.ssh
RUN ssh-keygen -q -f id_rsa -N ""
RUN cp id_rsa.pub authorized_keys
RUN mkdir -p /var/run/sshd

COPY supervisord.conf /etc/supervisor/supervisord.conf

WORKDIR /root
COPY simulation.sh /root/simulation.sh
RUN chmod a+x /root/simulation.sh

RUN ./rrsenv/script/rrscluster cfg-template

# clean up
#RUN apt-get upgrade -y && apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* 


ENTRYPOINT "/root/simulation.sh"
