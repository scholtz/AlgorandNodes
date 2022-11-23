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
ARG ALGO_BRANCH
RUN git clone https://github.com/algorand/go-algorand.git && cd go-algorand && git checkout $ALGO_BRANCH
RUN sed -i '26i  algodtxqueue "github.com/Diatomix/algod-tx-queue"' go-algorand/data/pools/transactionPool.go\
&& sed -i '450i algodtxqueue.MustStreamTxGroup(txgroup)' go-algorand/data/pools/transactionPool.go\
&& sed -i '7i   github.com/Diatomix/algod-tx-queue v0.0.0-20221122134749-fb3b0c188705' go-algorand/go.mod\
#&& sed -i '43i   github.com/Diatomix/algod-tx-queue v0.0.0-20221122134749-fb3b0c188705' go-algorand/go.sum\
#&& sed -i '44i   github.com/Diatomix/algod-tx-queue v0.0.0-20221122134749-fb3b0c188705' go-algorand/go.sum\
&& cat go-algorand/data/pools/transactionPool.go

ARG ssh_prv_key
ARG ssh_pub_key
# Authorize SSH Host
RUN mkdir -p /root/.ssh && \
    chmod 0700 /root/.ssh && \
    ssh-keyscan github.com > /root/.ssh/known_hosts

# Add the keys and set permissions
RUN echo "$ssh_prv_key" > /root/.ssh/id_rsa && \
    echo "$ssh_pub_key" > /root/.ssh/id_rsa.pub && \
    chmod 600 /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa.pub

WORKDIR /go-algorand

ENV GOPRIVATE github.com/Diatomix
RUN git config --global url.git@github.com:.insteadOf https://github.com/
 
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts
RUN go mod tidy -compat=1.17

# ARAMID - allow more than 1024 bytes in note field
RUN sed "~s/MaxTxnNoteBytes:     1024/MaxTxnNoteBytes:     131072/g" config/consensus.go && cat config/consensus.go | grep MaxTxnNoteBytes

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


