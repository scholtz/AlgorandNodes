
# # Base image
# FROM ubuntu:latest
# USER root
# RUN apt update && apt dist-upgrade -y && apt install -y bc mc wget telnet git curl net-tools iotop atop vim dnsutils jq iproute2 && apt-get autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/
# USER gora

# # Set working directory
# WORKDIR /home/gora
# ARG GORA_VER
# RUN echo "https://download.gora.io/$GORA_VER/linux/gora"

# # Update
# # Download entrypoint.sh from GitHub
# ADD entrypoint.sh /home/gora/entrypoint.sh
# USER root
# RUN chmod +x /home/gora/entrypoint.sh
# RUN chmod +x /home/gora/gora
# USER gora
# # Set the entrypoint to run the script
# ENTRYPOINT ["/home/gora/entrypoint.sh"]


ARG GORA_VER

# Base image
FROM public.ecr.aws/g4c3r1u3/gora-nr:v$GORA_VER
#USER root
#RUN apk update && apk upgrade  --available && apk add bc mc wget telnet git curl net-tools iotop atop vim dnsutils jq iproute2 && rm -rf /var/lib/{apt,apk,dpkg,cache,log}/
USER gora

# Set working directory
WORKDIR /opt/goracle/node_runner
RUN cat /etc/os-release
RUN whoami
# Update
# Download entrypoint.sh from GitHub
ADD entrypoint.sh /opt/goracle/node_runner/entrypoint.sh
USER root
RUN chmod +x /opt/goracle/node_runner/entrypoint.sh
USER gora
# Set the entrypoint to run the script
ENTRYPOINT ["/opt/goracle/node_runner/entrypoint.sh"]