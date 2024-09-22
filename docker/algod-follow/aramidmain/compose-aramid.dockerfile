ARG ALGO_VER

FROM scholtz2/aramid-algo-node:$ALGO_VER
USER algo
COPY --chown=algo:algo . .
CMD ["/bin/bash","-ec","/app/run.sh"]
