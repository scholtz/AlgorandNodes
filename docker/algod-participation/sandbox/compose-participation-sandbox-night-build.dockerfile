FROM scholtz2/algorand-relay-mainnet:night-build as build

FROM scholtz2/algorand-participation-sandbox:4.0.3-stable
RUN cd /node && find /node -maxdepth 1 -type f -delete
COPY --from=build /usr/local/algo/bin /node/
