FROM ubuntu:latest
MAINTAINER John Heatherington <john.heatherington@rackspace.com>

# Update packages
RUN apt-get -qq update && apt-get -qq upgrade && apt-get install -qqy \
    git-core \
    libev4 \
    libev-dev \
    libffi-dev \
    libssl-dev \
    python-dev \
    python-pip \
    python-setuptools

VOLUME /home/rse

# Install dependencies
RUN pip install -U pip
RUN pip install -U \
    gunicorn \
    webob

# rse-util
RUN mkdir -p /home/rse-util
RUN git clone https://github.com/rackerlabs/rse-util.git /home/rse-util
RUN pip install -e /home/rse-util

# rse
ADD . /home/rse
RUN pip install -e /home/rse

# rse configurations
ADD rse.docker.conf /etc/rse.conf

# Deploy startup script
ADD docker_init.sh /usr/local/bin/rse-docker
RUN chmod 755 /usr/local/bin/rse-docker

EXPOSE 8000

WORKDIR /home/rse
CMD rse-docker
