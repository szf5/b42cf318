FROM centos:6
ENV container docker
RUN yum install -y epel-release gcc-c++ make
RUN curl -sL https://rpm.nodesource.com/setup_11.x | bash -
RUN yum install -y git nodejs

# RUN npm install -g bats
RUN cd /root && git clone https://github.com/sstephenson/bats.git && cd bats && ./install.sh /usr/local

RUN cp -f /usr/share/zoneinfo/Japan /etc/localtime

