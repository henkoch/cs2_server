############################################################
# Dockerfile that contains SteamCMD
############################################################
FROM ubuntu as build_stage

# docker build --tag steam_ubuntu:0.1.0 .
# docker run -it steam_ubuntu:0.1.0 bash
# docker run -it  --volume /home/hck/Downloads/csgo_app:/data/steam/csgo_app --volume /home/hck/Dropbox/Sources/Servers/csgo_server/csgo_scripts:/data/steam/csgo_scripts steam_ubuntu:0.1.0 bash
# cd ~/
# mkdir ~/csgo_app
# export LD_LIBRARY_PATH=/home/steam/steamcmd/linux32
# time ~/steamcmd/steamcmd.sh +force_install_dir ~/csgo_app/ +login anonymous +app_update 740 validate +quit
# export LD_LIBRARY_PATH=/data/steam/csgo_app/bin
# /data/steam/csgo_app/srcds_linux -game csgo -usercon -net_port_try 1 -tickrate 128 -nobots +game_type 0 +game_mode 1 +mapgroup mg_active +map de_mirage


ARG PUID=1000

ENV USER steam
ENV HOMEDIR "/data/${USER}"
ENV STEAMCMDDIR "${HOMEDIR}/steamcmd"

RUN apt update -y && apt upgrade -y

RUN mkdir /data
RUN useradd --home-dir "${HOMEDIR}" --create-home -u "${PUID}" --shell /usr/bin/bash ${USER}

# Insert Steam prompt answers
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo steam steam/question select "I AGREE" | debconf-set-selections \
 && echo steam steam/license note '' | debconf-set-selections

# Update the repository and install SteamCMD
ARG DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture i386 \
 && apt-get update -y \
 && apt-get install -y --no-install-recommends --no-install-suggests \
      ca-certificates\
      curl\
      locales\
      libcurl4-gnutls-dev:i386\
      lib32gcc-s1\
      lib32stdc++6\
      steamcmd\
      vim

RUN  sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
	&& dpkg-reconfigure --frontend=noninteractive locales

RUN mkdir ${HOMEDIR}/.steam
RUN chown ${USER}:${USER} ${HOMEDIR}/.steam


# Clean up
RUN apt-get remove --purge --auto-remove -y \
	&& rm -rf /var/lib/apt/lists/*

FROM build_stage AS ubuntu-root
WORKDIR ${STEAMCMDDIR}

#FROM bullseye-root AS bullseye
## Switch to user
#USER ${USER}
