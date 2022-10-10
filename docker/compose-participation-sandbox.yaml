ARG ALGO_VER

FROM scholtz2/algorand-kmd-mainnet-extended:$ALGO_VER-stable
COPY . . 
USER root
RUN chown algo:algo /app -R
USER algo

RUN wget https://raw.githubusercontent.com/algorand/sandbox/master/images/algod/setup.py
RUN chmod 0700 setup.py
RUN mkdir /app/net
RUN ls -la /app
RUN ./setup.py  --bin-dir /node --data-dir "/app/net/data"  --algod-port "4001" --kmd-port "4002" --start-script /app/run-participation.sh --network-template "/app/sandbox/template.json" --network-token "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" --network-dir "/app/net"  --bootstrap-url "" --genesis-file ""
RUN cp /app/net/Node/* /app/data -rf
COPY run-participation.sh run-participation.sh 
COPY ./sandbox/config.json /app/data/config.json
RUN cat /app/data/config.json
USER root
RUN chmod 0700 /app/run-participation.sh
RUN chown algo:algo  /app/run-participation.sh
RUN chmod 0700 /app/data/config.json
RUN chown algo:algo  /app/data/config.json
USER algo
CMD ["/app/run-participation.sh"]