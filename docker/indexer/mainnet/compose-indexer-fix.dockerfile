FROM ubuntu:latest as build
USER root
ENV ARCH=amd64
ENV DEBIAN_FRONTEND noninteractive
RUN apt update && apt dist-upgrade -y && apt install -y mc wget telnet git net-tools iotop atop vim make  gcc build-essential aptly awscli binutils build-essential curl gnupg2 libboost-all-dev sqlite3 autoconf jq bsdmainutils shellcheck && apt-get clean autoclean && apt-get autoremove --yes &&  rm -rf /var/lib/{apt,dpkg,cache,log}/
ENV GOPATH=/usr/local/algo
ENV GOROOT=/usr/local/go
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH
ENV GOPROXY=https://proxy.golang.org,https://pkg.go.dev,https://goproxy.io,direct
RUN wget https://golang.org/dl/go1.17.11.linux-amd64.tar.gz && rm -rf $GOPATH && tar -C /usr/local -xzf go1.17.11.linux-amd64.tar.gz && go version
RUN git clone https://github.com/algorand/go-algorand.git /go-algorand && cd /go-algorand
WORKDIR /go-algorand
RUN ./scripts/configure_dev.sh
RUN ./scripts/buildtools/install_buildtools.sh

RUN echo 7
ARG TAG
RUN git clone https://github.com/algorand/indexer.git /indexer && cd /indexer && git checkout $TAG
WORKDIR /indexer
RUN sed -i '20i  goconfig "github.com/algorand/go-algorand/config"' cmd/algorand-indexer/daemon.go
RUN sed -i '275i  if err = loadCustomConsensus(daemonConfig.indexerDataDir); err != nil {' cmd/algorand-indexer/daemon.go
RUN sed -i '276i  return err' cmd/algorand-indexer/daemon.go
RUN sed -i '277i  }' cmd/algorand-indexer/daemon.go
COPY fix.go.txt fix.go.txt
RUN cat fix.go.txt >> cmd/algorand-indexer/daemon.go
RUN make
#RUN cat cmd/algorand-indexer/daemon.go && exit 1
RUN ls -lA
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
RUN apt update && apt dist-upgrade -y && apt install -y mc wget telnet git curl net-tools iotop atop vim dnsutils jq && apt-get autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/
COPY --from=build /usr/local/algo/bin /usr/local/algo/bin
COPY --from=build /indexer /indexer
COPY --from=build /indexer/cmd/algorand-indexer/algorand-indexer /usr/local/algo/bin/algorand-indexer
ENV GOPATH=/usr/local/algo
RUN mkdir /app
ENV PATH=$GOPATH/bin:$PATH
WORKDIR /app
RUN echo 3
COPY . . 
RUN useradd -ms /bin/bash algo
RUN chown algo:algo /app -R
USER algo

RUN chmod 0700 /app/run.sh

CMD ["/bin/bash", "/app/run.sh"]


