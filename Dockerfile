FROM ubuntu:18.04

LABEL package.date=2022-01-16

ARG DEBIAN_FRONTEND=noninteractive

RUN set -e;

RUN apt-get update && \
    apt-get install -y gnupg apt-transport-https wget software-properties-common gpg lsb-release curl tini && \
    wget -q https://xpra.org/gpg.asc -O- | apt-key add - && \
    add-apt-repository "deb https://xpra.org/ bionic main" && \
    wget -q https://qgis.org/downloads/qgis-2021.gpg.key -O- | gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/qgis-archive.gpg --import && \
    chmod a+r /etc/apt/trusted.gpg.d/qgis-archive.gpg && \
    add-apt-repository "deb https://qgis.org/ubuntu $(lsb_release -c -s) main" && \
    gcsFuseRepo=gcsfuse-`lsb_release -c -s` && \
    echo "deb http://packages.cloud.google.com/apt $gcsFuseRepo main" && \
    tee /etc/apt/sources.list.d/gcsfuse.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg && \
    apt-key add - && \
    apt-get update && \
    apt-get install -y xpra qgis qgis-plugin-grass gcsfuse && \
    apt-get clean

ENV MNT_DIR /home/GFUSE

COPY . ./

# Ensure the script is executable
RUN chmod +x /start.sh

CMD ["/start.sh"]