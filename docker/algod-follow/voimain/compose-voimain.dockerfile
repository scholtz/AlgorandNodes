ARG ALGO_VER

FROM scholtz2/algorand-relay-voimain:$ALGO_VER
USER algo
COPY config.json config.json
CMD /app/run.sh