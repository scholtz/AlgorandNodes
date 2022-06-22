ARG ALGO_VER

FROM scholtz2/algorand-relay-mainnet:$ALGO_VER
USER root

COPY . . 
RUN chmod 0777 *.sh

USER algo
