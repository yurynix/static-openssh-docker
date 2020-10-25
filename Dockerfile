FROM ubuntu
WORKDIR /workdir
COPY . /workdir
RUN chmod +x build.sh
RUN mkdir dist
RUN apt-get update && apt-get install build-essential curl -y
RUN curl https://ftp.hostserver.de/pub/OpenBSD/OpenSSH/portable/openssh-8.4p1.tar.gz > ./dist/openssh-8.4p1.tar.gz
RUN curl https://zlib.net/zlib-1.2.11.tar.gz > ./dist/zlib-1.2.11.tar.gz
RUN curl https://www.openssl.org/source/openssl-1.1.1h.tar.gz > ./dist/openssl-1.1.1h.tar.gz
RUN ./build.sh