FROM debian:buster

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y gnupg apt-transport-https wget software-properties-common gpg lsb-release && \
    wget -q https://xpra.org/gpg.asc -O- | apt-key add - && \
    add-apt-repository "deb https://xpra.org/ $(lsb_release -c -s) main" && \
    wget -q https://qgis.org/downloads/qgis-2021.gpg.key -O- | gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/qgis-archive.gpg --import && \
    chmod a+r /etc/apt/trusted.gpg.d/qgis-archive.gpg && \
    add-apt-repository "deb https://qgis.org/debian $(lsb_release -c -s) main" && \
    apt-get update && \
    apt-get install -y xpra qgis qgis-plugin-grass

# Install system dependencies
RUN set -e; \
    apt-get update -y && apt-get install -y \
    tini \
    curl \
    lsb-release; \
    gcsFuseRepo=gcsfuse-`lsb_release -c -s`; \
    echo "deb http://packages.cloud.google.com/apt $gcsFuseRepo main" | \
    tee /etc/apt/sources.list.d/gcsfuse.list; \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    apt-key add -; \
    apt-get update; \
    apt-get install -y gcsfuse \
    && apt-get clean

ENV MNT_DIR /home/GFUSE

COPY . ./

# Ensure the script is executable
RUN chmod +x /start.sh

CMD ["/start.sh"]