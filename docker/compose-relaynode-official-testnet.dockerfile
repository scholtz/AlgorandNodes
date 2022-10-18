ARG ALGO_VER

FROM algorand/stable:$ALGO_VER
USER root
ENV DEBIAN_FRONTEND noninteractive
RUN apt update && apt dist-upgrade -y && apt install -y mc wget telnet git curl net-tools iotop atop vim dnsutils jq iproute2 && apt-get autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/
ENV ALGORAND_DATA=/app/data
RUN mkdir /app
RUN mkdir /app/data
RUN mkdir /app/testnet
RUN mv /root/node /node
RUN cp /node/genesisfiles/testnet/genesis.json /app/testnet/genesis.json
ENV PATH=/node:$PATH
WORKDIR /app
COPY . . 
RUN useradd -ms /bin/bash algo
RUN chown algo:algo /app -R
RUN chown algo:algo /node -R
RUN chmod 0700 /app/health.sh
RUN chmod 0700 /app/run.sh
USER algo
CMD ["/bin/bash"]


