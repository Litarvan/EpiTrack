FROM alpine:3.11.6

LABEL maintainer="Adrien Navratil <adrien1975@live.fr>"

# Inspired from : https://github.com/PyPlanet/maniaplanet-docker
# Thanks to Tom Valk :^)

ENV SERVER_URL http://files.v04.maniaplanet.com/server/ManiaplanetServer_Latest.zip
ENV SERVER_ROOT /var/run/epitrack
ENV USER epitrack

# We create the server runner user
RUN addgroup -g 1000 $USER && adduser -u 1000 -D -G $USER $USER

# Link the musl to glibc as it's compatible (required in Alpine image).
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
 && wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.31-r0/glibc-2.31-r0.apk \
 && apk add glibc-2.31-r0.apk libstdc++ musl libuuid wget

ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/lib/:/lib/"

# Setup the root and install the dedicated server
RUN mkdir -p $SERVER_ROOT
WORKDIR $SERVER_ROOT

RUN wget $SERVER_URL -qO /tmp/server.zip

RUN unzip -q /tmp/server.zip -d ./ \
    && rm /tmp/server.zip \
    && rm -rf ./*.bat ./*.exe ./*.html ./RemoteControlExamples

COPY scripts/starter.sh ./start.sh

# Setting permissions
RUN chown -R $USER:$USER ./
RUN chmod u+x ./start.sh
RUN chmod u+x ./ManiaPlanetServer

# Setting up !
USER $USER
EXPOSE 2350/tcp 2350/udp 3250/tcp 3250/udp
CMD ["./start.sh"]