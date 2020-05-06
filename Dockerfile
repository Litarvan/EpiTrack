FROM python:3.8-slim

LABEL maintainer="Adrien Navratil <adrien1975@live.fr>"

# Inspired from : https://github.com/PyPlanet/maniaplanet-docker and https://github.com/PyPlanet/docker
# Thanks to Tom Valk <tomvalk@lt-box.info> :^)

ENV SERVER_URL http://files.v04.maniaplanet.com/server/ManiaplanetServer_Latest.zip
ENV SERVER_ROOT /var/run/epitrack
ENV USER epitrack

ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/lib/:/lib/"

# Creating the server runner user
RUN addgroup --gid 1000 $USER && adduser -u 1000 --group $USER --system

# Setting up the root
RUN mkdir -p $SERVER_ROOT
WORKDIR $SERVER_ROOT

COPY scripts/starter.sh ./start.sh

# Installing
RUN \
    # Installing the dependencies
    apt-get -q update && \
    apt-get install -y build-essential libssl-dev libffi-dev zlib1g-dev wget unzip && \
    rm -rf /var/lib/apt/lists/* && \
    \
    # Installing the server
    wget $SERVER_URL -qO /tmp/server.zip && \
    unzip -q /tmp/server.zip -d ./ && \
    rm /tmp/server.zip && \
    rm -rf ./*.bat ./*.exe ./*.html ./RemoteControlExamples && \
    \
    # Installing the PyPlanet controller
    pip3 install pyplanet --upgrade && \
    pyplanet init_project controller && \
    rm -r controller/settings && \
    \
    # Cleaning
    rm -rf /root/.cache && \
    apt-get remove -y --autoremove --purge libssl-dev build-essential libffi-dev zlib1g-dev wget unzip && \
    \
    # Setting permissions
    chown -R $USER:$USER ./ && \
    chmod u+x ./start.sh && \
    chmod u+x ./ManiaPlanetServer

# Setting up !
USER $USER
EXPOSE 2350/tcp 2350/udp 3250/tcp 3250/udp
CMD ["./start.sh"]