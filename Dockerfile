FROM haskell:7.10.2
MAINTAINER Garry Cairns
ENV REFRESHED_AT 2015-09-05

# install wget
RUN ["apt-get", "-y", "update"]
RUN ["apt-get", "-y", "install", "wget"]

# move into our working directory
RUN ["groupadd", "haskell"]
RUN ["useradd", "haskell", "-s", "/bin/bash", "-m", "-g", "haskell", "-G", "haskell"]
ENV HOME /home/haskell
WORKDIR /home/haskell
RUN ["chown", "-R", "haskell:haskell", "/home/haskell"]

# install stack
RUN wget -q -O- https://s3.amazonaws.com/download.fpcomplete.com/debian/fpco.key | apt-key add -
RUN echo 'deb http://download.fpcomplete.com/debian/jessie stable main'|tee /etc/apt/sources.list.d/fpco.list
RUN apt-get update && apt-get install stack -y

# add our code
ADD ./app /home/haskell
