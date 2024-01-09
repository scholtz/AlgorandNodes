FROM ubuntu:latest as build
USER root
ENV ARCH=amd64
ENV DEBIAN_FRONTEND noninteractive
RUN apt update && apt dist-upgrade -y && apt install -y bc mc wget telnet git net-tools iotop atop vim make  gcc build-essential aptly awscli binutils build-essential curl gnupg2 libboost-all-dev sqlite3 autoconf jq bsdmainutils shellcheck && apt-get clean autoclean && apt-get autoremove --yes &&  rm -rf /var/lib/{apt,dpkg,cache,log}/
ENV GOPATH=/usr/local/algo
ENV GOROOT=/usr/local/go
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH
ENV GOPROXY=https://proxy.golang.org,https://pkg.go.dev,https://goproxy.io,direct
RUN wget https://golang.org/dl/go1.20.12.linux-amd64.tar.gz	 && rm -rf $GOPATH && tar -C /usr/local -xzf go1.20.12.linux-amd64.tar.gz	&& go version
COPY . /code
WORKDIR /code/AramidConduit
RUN make



FROM ubuntu:latest as final
USER root
ENV DEBIAN_FRONTEND noninteractive
RUN apt update && apt dist-upgrade -y && apt install -y bc mc wget telnet git curl net-tools iotop atop vim dnsutils jq && apt-get autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/
COPY --from=build /code/AramidConduit/cmd/conduit/conduit /usr/local/bin/conduit
RUN useradd -ms /bin/bash -d /data -u 999 algo
WORKDIR /data
RUN chown algo:algo /data -R
USER algo
ENV CONDUIT_DATA_DIR /data

CMD ["conduit"]


