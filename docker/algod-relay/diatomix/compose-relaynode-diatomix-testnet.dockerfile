ARG DIATOMIX_TAG
ARG ALGO_TAG

FROM algorand/stable:$ALGO_TAG as algo
WORKDIR /root/node/genesisfiles/
RUN ls

FROM scholtz2/diatomix-relay-mainnet:$DIATOMIX_TAG
COPY --from=algo /root/node/genesisfiles/testnet/genesis.json /app/testnet/genesis.json
WORKDIR /app
COPY . . 
USER root
RUN chown algo:algo /app -R
RUN chmod 0700 /app/health.sh
RUN chmod 0700 /app/run.sh
USER algo
RUN cat /app/run.sh
CMD ["/bin/bash"]


