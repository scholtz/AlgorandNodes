FROM node:16 AS build
USER root
ENV DEBIAN_FRONTEND noninteractive
RUN apt update && apt dist-upgrade -y && apt install -y mc wget telnet git net-tools iotop atop vim make  gcc build-essential aptly awscli binutils build-essential curl gnupg2 libboost-all-dev sqlite3 autoconf jq bsdmainutils shellcheck && apt-get clean autoclean && apt-get autoremove --yes &&  rm -rf /var/lib/{apt,dpkg,cache,log}/
RUN npm install -g npm@9.2.0
WORKDIR /src
RUN mkdir dappflow \
&& cd dappflow \
&& wget https://raw.githubusercontent.com/algodesk-io/dappflow/master/package.json \
&& yarn install
#ARG CACHEBUST
#RUN echo "$CACHEBUST"
RUN git clone https://github.com/algodesk-io/dappflow dappflow2 \
&& cd dappflow2 \
&& cp -Rpf . ../dappflow
WORKDIR /src/dappflow
RUN ls
RUN yarn install
RUN npx browserslist@latest --update-db
RUN yarn build
RUN cd /src/dappflow/build && ls
#RUN npm run test

FROM nginxinc/nginx-unprivileged:latest
USER root
ENV DEBIAN_FRONTEND noninteractive
RUN apt update && apt dist-upgrade -y && apt install -y mc wget telnet git curl iotop atop vim && apt-get clean autoclean && apt-get autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/
RUN mkdir /app
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
RUN chown nginx:nginx /etc/nginx/conf.d -R
RUN chmod 0600 /etc/nginx/conf.d -R
RUN chmod 0700 /etc/nginx/conf.d
USER nginx
WORKDIR /app
COPY --from=build /src/dappflow/build .
RUN pwd && ls