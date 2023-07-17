ARG GORACLE_VER

# Base image
FROM public.ecr.aws/g4c3r1u3/goracle-nr:$GORACLE_VER
USER root
RUN apk update && apk upgrade  --available && apk add mc wget git curl net-tools iotop atop vim jq iproute2 && rm -rf /var/lib/{apt,apk,dpkg,cache,log}/
USER goracle

# Set working directory
WORKDIR /opt/goracle/node_runner
RUN cat /etc/os-release
RUN whoami
# Update
# Download entrypoint.sh from GitHub
ADD entrypoint.sh /opt/goracle/node_runner/entrypoint.sh
USER root
RUN chmod +x /opt/goracle/node_runner/entrypoint.sh
USER goracle
# Set the entrypoint to run the script
ENTRYPOINT ["/opt/goracle/node_runner/entrypoint.sh"]