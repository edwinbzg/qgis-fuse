FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y gnupg apt-transport-https wget software-properties-common gpg lsb-release && \
    wget -q https://xpra.org/gpg.asc -O- | apt-key add - && \
    add-apt-repository "deb https://xpra.org/ bionic main" && \
    wget -q https://qgis.org/downloads/qgis-2021.gpg.key -O- | gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/qgis-archive.gpg --import && \
    chmod a+r /etc/apt/trusted.gpg.d/qgis-archive.gpg && \
    add-apt-repository "deb https://qgis.org/ubuntu $(lsb_release -c -s) main" && \
    apt-get update && \
    apt-get install -y xpra qgis qgis-plugin-grass

CMD xpra start --start=qgis --bind-tcp=0.0.0.0:8080 --html=on && tail -f /dev/null
