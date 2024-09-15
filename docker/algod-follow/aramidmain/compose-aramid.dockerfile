ARG ALGO_VER

FROM scholtz2/aramid-algo-node:$ALGO_VER
USER algo
COPY config.json config.json
CMD /app/run.sh