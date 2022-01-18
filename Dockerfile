FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y

RUN apt-get install iproute2 -y

RUN apt-get install hping3 -y

RUN apt-get install iputils-ping -y

RUN apt-get install tcpdump -y

RUN apt-get install nmap -y

RUN apt-get install net-tools -y

RUN apt-get install htop -y

ENTRYPOINT ["sleep", "infinity"]
