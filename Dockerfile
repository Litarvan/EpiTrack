FROM python:3.8

LABEL maintainer="Adrien Navratil <adrien1975@live.fr>"

# Inspired from : https://github.com/PyPlanet/maniaplanet-docker and https://github.com/PyPlanet/docker
# Thanks to Tom Valk <tomvalk@lt-box.info> :^)

ENV SERVER_URL http://files.v04.maniaplanet.com/server/ManiaplanetServer_Latest.zip
ENV SERVER_ROOT /var/run/epitrack
ENV USER epitrack

# We create the server runner user
RUN addgroup --gid 1000 $USER && adduser -u 1000 --group $USER --system

RUN apt-get -q update \
  && apt-get install -y build-essential libssl-dev libffi-dev zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/lib/:/lib/"

# Setup the root and install the dedicated server
RUN mkdir -p $SERVER_ROOT
WORKDIR $SERVER_ROOT

RUN wget $SERVER_URL -qO /tmp/server.zip

RUN unzip -q /tmp/server.zip -d ./ \
    && rm /tmp/server.zip \
    && rm -rf ./*.bat ./*.exe ./*.html ./RemoteControlExamples

COPY scripts/starter.sh ./start.sh

# Install PyPlanet
RUN pip3 install pyplanet --upgrade

RUN pyplanet init_project controller
RUN rm -r controller/settings

# Cleaning
RUN rm -rf /root/.cache
RUN apt-get remove -y --autoremove libssl-dev build-essential libffi-dev zlib1g-dev

# Setting permissions
RUN chown -R $USER:$USER ./
RUN chmod u+x ./start.sh
RUN chmod u+x ./ManiaPlanetServer

# Setting up !
USER $USER
EXPOSE 2350/tcp 2350/udp 3250/tcp 3250/udp
CMD ["./start.sh"]