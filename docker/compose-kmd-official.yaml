ARG ALGO_VER

FROM scholtz2/algorand-relay-mainnet:$ALGO_VER-stable
USER algo
COPY . . 
USER root
RUN chown algo:algo run-kmd.sh
RUN chmod 0700 run-kmd.sh
USER algo
