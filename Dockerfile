FROM ubuntu

RUN echo "Upgrades"
RUN apt-get update -y
RUN apt-get upgrade -y

RUN echo "Essentials"
RUN apt-get install -y build-essential
RUN apt-get install -y git

RUN apt-get install software-properties-common -y
RUN add-apt-repository -y ppa:ethereum/ethereum -y
RUN apt-get install net-tools

RUN apt-get install vim -y
RUN apt-get install curl -y
RUN apt-get install wget -y

RUN echo "Install Swarm"
RUN apt-get install ethereum-swarm -y

RUN mkdir /eth
RUN mkdir /eth/gethData

COPY build/accounts/keystore /eth/gethData/keystore

COPY build/geth100000/geth /usr/local/bin
COPY build/genesis.json /eth

EXPOSE 8500 8545 8546 30303 30303/udp
