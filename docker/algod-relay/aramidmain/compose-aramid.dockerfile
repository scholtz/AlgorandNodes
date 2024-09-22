ARG ALGO_VER

FROM scholtz2/algorand-relay-mainnet:$ALGO_VER
USER algo
COPY --chown=algo:algo . .
USER algo
CMD ["/bin/bash","-ec","/app/run.sh"]
