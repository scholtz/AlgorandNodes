FROM ubuntu
USER root
ENV DEBIAN_FRONTEND noninteractive
RUN apt update && apt dist-upgrade -y && apt install -y bc mc wget telnet git curl net-tools iotop atop vim dnsutils jq && apt-get autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN mkdir /install
WORKDIR /install
ARG INDEXER_VER
ENV INDEXER_VER=$INDEXER_VER
RUN echo "INDEXER_VER: $INDEXER_VER"
RUN ver=$(echo $INDEXER_VER | sed 's/v//')\
&& link="https://github.com/algorand/indexer/releases/download/${INDEXER_VER}/indexer_${ver}_amd64.deb" \
&& echo "downloading $link"\
&& wget $link\
&& dpkg -i "indexer_${ver}_amd64.deb"
#RUN wget "https://github.com/algorand/indexer/releases/download/${INDEXER_VER}/algorand-indexer_${INDEXER_VER}_amd64.deb.sig"
RUN mkdir /app
WORKDIR /app

#RUN gpg --verify algorand-indexer_2.6.5_amd64.deb.sig algorand-indexer_2.6.5_amd64.deb
COPY . . 
RUN useradd -ms /bin/bash algo
RUN chown algo:algo /app -R
RUN algorand-indexer help

RUN chmod 0700 /app/run.sh

CMD ["/app/run.sh"]



