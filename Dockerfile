FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
#Core
RUN mkdir /app
WORKDIR /app
#Add Universe and multiverse repository
RUN apt update && apt upgrade -y && apt install -y software-properties-common && apt update && add-apt-repository universe && add-apt-repository multiverse
#install basics packages
#install required packages to compile source
#install dependencies for megatools experimental 1.11.0 (meson also)
#install fusermount3 for rclone 
#Install software (meson for installing megatools experimenal)
RUN apt update && apt install -y --no-install-recommends \
        php nodejs python3.8 npm curl wget git python3-pip net-tools alien \
        build-essential libssl-dev checkinstall pkg-config cmake ninja-build \
        libglib2.0-dev libcurl4-openssl-dev asciidoc \
        fuse \
        nano \
        zip unzip p7zip-full rar unrar \
        aria2 \
        ffmpeg \
        fakeroot \
        openssh-server \
  && pip3 install --upgrade \
          youtube-dl \
          meson \
  && npm install -g \
          localtunnel \
  && apt autoclean \
  && apt autoremove \
  && rm -rf /var/lib/apt/lists/*
#TelegramBot
RUN git clone https://github.com/Frozen12/TelegramShellBot-Rclone.git && cd TelegramShellBot-Rclone && npm install
#install megatools
#RUN git clone https://megous.com/git/megatools && cd megatools && meson b && ninja -C b && ninja -C b install && rm -rf ~/megatools
CMD cd TelegramShellBot-Rclone && . ./setup.sh && bash start.sh
