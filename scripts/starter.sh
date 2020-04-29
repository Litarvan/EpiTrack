#!/bin/sh
echo "EpiTrack TM2 dedicated server"

PACK=TMStadium@nadeo.Title.Pack.gbx

echo "=> Downloading newest TMStadium title version"
mkdir -p ./UserData/Packs
wget https://v4.live.maniaplanet.com/ingame/public/titles/download/$PACK -qO ./UserData/Packs/$PACK

echo "=> Starting server on ${HOST}, login=${LOGIN}"
echo

./ManiaPlanetServer $@ \
    /nodaemon \
    /forceip=${HOST} \
    /title=TMStadium@nadeo \
    /dedicated_cfg=server.xml \
    /game_settings=MatchSettings/match.xml \
    /login=${LOGIN} \
    /password=${PASSWORD}

echo "Stopped"
echo