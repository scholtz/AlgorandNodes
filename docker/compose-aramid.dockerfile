ARG ALGO_VER

FROM scholtz2/algorand-relay-mainnet:$ALGO_VER
USER algo
COPY . . 
USER root
RUN chmod 0777 *.sh
USER algo
CMD /app/run.sh