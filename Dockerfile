#FROM debian:jessie
FROM ubuntu:16.04
#MAINTAINER kost - https://github.com/kost

ENV	ZCASH_URL=https://github.com/zcash/zcash.git \
	ZCASH_VERSION=v1.0.14

RUN apt-get update && apt-get upgrade -y && apt-get autoclean && apt-get autoremove

RUN apt-get -qqy install --no-install-recommends build-essential \
    automake ncurses-dev libcurl4-openssl-dev libssl-dev libgtest-dev \
    make autoconf automake libtool git apt-utils pkg-config libc6-dev \
    libcurl3-dev libudev-dev m4 g++-multilib unzip git python zlib1g-dev \
    wget ca-certificates pwgen bsdmainutils curl

# RUN rm -rf /var/lib/apt/lists/*
RUN mkdir -p /src/zcash/ && cd /src/zcash && \
    git clone ${ZCASH_URL} zcash && cd zcash && git checkout ${ZCASH_VERSION}

RUN cd /src/zcash/zcash && ./zcutil/fetch-params.sh

RUN cd /src/zcash/zcash && ./zcutil/build.sh -j4 && cd /src/zcash/zcash/src && \
    /usr/bin/install -c zcash-tx zcashd zcash-cli zcash-gtest -t /usr/local/bin/

# RUN rm -rf /src/zcash/ && \
ARG UNAME=zcash
ARG UID=1000
ARG GID=1000

RUN groupadd -g $GID $UNAME && \
    useradd -m -u $UID -g $GID -s /bin/bash $UNAME

RUN mv /root/.zcash-params /home/${UNAME}/ && \
    mkdir -p /home/${UNAME}/.zcash/ && \
    chown -R $UNAME:$UNAME /home/${UNAME} && \
    echo "Success"

USER ${UNAME}
RUN echo "rpcuser=${UNAME}" > /home/${UNAME}/.zcash/zcash.conf && \
	echo "rpcpassword=`pwgen 20 1`" >> /home/${UNAME}/.zcash/zcash.conf && \
	echo "addnode=mainnet.z.cash" >> /home/${UNAME}/.zcash/zcash.conf && \
	echo "Success"

VOLUME ["/home/${UNAME}/.zcash"]
