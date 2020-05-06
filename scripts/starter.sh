#!/bin/sh
echo "EpiTrack TM2 dedicated server"

PACK=./UserData/Packs/esl_comp.lt_forever.Title.Pack.gbx

if ! [ -f $PACK ]; then
  echo "=> Downloading ESL Competition title pack"
  mkdir -p ./UserData/Packs
  wget https://github.com/KemTM/competition-titlepack/releases/download/v0.4.6/esl_comp.lt_forever.Title.Pack.gbx -qO $PACK
fi

echo "=> Starting server on ${HOST}, login=${LOGIN}"
echo

./ManiaPlanetServer $@ \
    /nodaemon \
    /forceip=${HOST} \
    /dedicated_cfg=server.xml \
    /game_settings=MatchSettings/match.xml \
    /login=${LOGIN} \
    /password=${PASSWORD} &

sleep 10

echo
echo "=> Starting PyPlanet server controller"
cd controller
IS_DOCKER=1 ./manage.py start --pool=default --settings=settings
cd ..

echo
echo "=> Stopped"
echo