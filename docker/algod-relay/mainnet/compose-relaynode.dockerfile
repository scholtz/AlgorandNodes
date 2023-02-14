FROM ubuntu:latest as build
USER root
ENV ARCH=amd64
ARG ALGO_VER
ENV DEBIAN_FRONTEND noninteractive
RUN apt update && apt dist-upgrade -y && apt install -y mc wget telnet git curl net-tools iotop atop vim dnsutils jq iproute2 && apt-get autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/
RUN apt update && apt dist-upgrade -y && apt install -y make gcc build-essential aptly awscli binutils build-essential gnupg2 libboost-all-dev sqlite3 autoconf bsdmainutils shellcheck && apt-get clean autoclean && apt-get autoremove --yes &&  rm -rf /var/lib/{apt,dpkg,cache,log}/
ENV GOPATH=/usr/local/algo
ENV GOROOT=/usr/local/go
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH
ENV GOPROXY=https://proxy.golang.org,https://pkg.go.dev,https://goproxy.io,direct
RUN wget https://golang.org/dl/go1.17.11.linux-amd64.tar.gz && rm -rf $GOPATH && tar -C /usr/local -xzf go1.17.11.linux-amd64.tar.gz && go version
ARG CACHEBUST
RUN echo "$CACHEBUST"
RUN git clone https://github.com/algorand/go-algorand.git && cd go-algorand  && git checkout $ALGO_VER

### TMP modification of the relay node until group sharing resources is available https://docs.google.com/document/d/17bx7GaCHf5XLFxEN8WBwsfIpDk1_OnUe8l0i6fIev3k/edit#
# MaxAppTotalTxnReferences = 8
# 
RUN sed -i 's~MaxAppTotalTxnReferences = 8~MaxAppTotalTxnReferences = 100~' go-algorand/config/consensus.go && cat go-algorand/config/consensus.go | grep MaxAppTotalTxnReferences

WORKDIR /go-algorand


# ARAMID - allow more than 1024 bytes in note field
#RUN sed "~s/MaxTxnNoteBytes:     1024/MaxTxnNoteBytes:     131072/g" config/consensus.go && cat config/consensus.go | grep MaxTxnNoteBytes

RUN ./scripts/configure_dev.sh
RUN ./scripts/buildtools/install_buildtools.sh
RUN ls -lA
RUN make
#RUN make test
#RUN make integration
#RUN make fmt
#RUN make lint
#RUN make fix
#RUN make vet
#RUN make sanity

FROM ubuntu:latest as final
USER root
ENV DEBIAN_FRONTEND noninteractive
RUN apt update && apt dist-upgrade -y &&  apt install -y mc wget telnet git curl net-tools iotop atop vim dnsutils jq iproute2 && apt-get autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/
COPY --from=build /usr/local/algo/bin /usr/local/algo/bin
ENV GOPATH=/usr/local/algo
ENV ALGORAND_DATA=/app/data
RUN mkdir /app
RUN mkdir /app/data
RUN mkdir /app/mainnet
COPY --from=build /go-algorand/installer/genesis/mainnet/genesis.json /app/mainnet/genesis.json
ENV PATH=$GOPATH/bin:$PATH
WORKDIR /app
RUN echo 3
COPY . . 
RUN useradd -ms /bin/bash algo
RUN chown algo:algo /app -R
USER algo
CMD ["/bin/bash"]