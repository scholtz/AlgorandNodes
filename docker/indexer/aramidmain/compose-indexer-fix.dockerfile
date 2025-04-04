FROM ubuntu:latest as build
USER root
ENV ARCH=amd64
ENV DEBIAN_FRONTEND noninteractive
RUN apt update && apt dist-upgrade -y && apt install -y bc mc wget telnet git net-tools iotop atop vim make  gcc build-essential aptly binutils build-essential curl gnupg2 libboost-all-dev sqlite3 autoconf jq bsdmainutils shellcheck && apt-get clean autoclean && apt-get autoremove --yes &&  rm -rf /var/lib/{apt,dpkg,cache,log}/
ENV GOPATH=/usr/local/algo
ENV GOROOT=/usr/local/go
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH
ENV GOPROXY=https://proxy.golang.org,https://pkg.go.dev,https://goproxy.io,direct
RUN wget https://golang.org/dl/go1.21.10.linux-amd64.tar.gz	 && rm -rf $GOPATH && tar -C /usr/local -xzf go1.21.10.linux-amd64.tar.gz	&& go version
COPY indexer-fix /code/indexer-fix
COPY go-algorand-sdk /code/go-algorand-sdk
WORKDIR /code/indexer-fix
RUN make
RUN ls -lA /code/indexer-fix/cmd/



FROM ubuntu:latest as final
USER root
ENV DEBIAN_FRONTEND noninteractive
RUN apt update && apt dist-upgrade -y && apt install -y bc mc wget telnet git curl net-tools iotop atop vim dnsutils jq && apt-get autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/
COPY --from=build /code/indexer-fix/cmd/algorand-indexer/algorand-indexer /usr/local/bin/algorand-indexer
RUN userdel -rf ubuntu && useradd -ms /bin/bash -d /app -u 1000 algo
WORKDIR /app
USER algo
RUN mkdir /app/data
ENV INDEXER_DATA /app/data
COPY --chown=algo:algo context .
RUN chmod +x /app/run.sh
CMD ["/bin/bash","-ec","/app/run.sh"]


