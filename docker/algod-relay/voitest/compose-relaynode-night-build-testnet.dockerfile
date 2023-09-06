FROM scholtz2/algorand-relay-mainnet:night-build
USER root
ENV DEBIAN_FRONTEND noninteractive
RUN apt update && apt dist-upgrade -y && apt install -y mc wget telnet git curl net-tools iotop atop vim dnsutils jq iproute2 && apt-get autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/
ENV ALGORAND_DATA=/app/data
RUN mkdir /app/testnet
RUN cp /node/genesisfiles/testnet/genesis.json /app/testnet/genesis.json
ENV PATH=/node:$PATH
WORKDIR /app
USER algo
COPY . . 
USER root
RUN chmod 0700 /app/health.sh
RUN chmod 0700 /app/run.sh
USER algo
CMD ["/bin/bash" "/app/run.sh"]
EXPOSE 24161
EXPOSE 28081
