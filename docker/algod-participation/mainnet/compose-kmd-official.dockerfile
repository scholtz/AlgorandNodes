ARG ALGO_VER

FROM scholtz2/algorand-relay-mainnet:$ALGO_VER-stable
USER algo
COPY . . 
USER root
RUN chown algo:algo * -R && chmod 0700 *.sh
USER algo
