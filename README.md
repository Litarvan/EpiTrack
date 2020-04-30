# EpiTrack - TM2 Stadium dedicated server

**Requires [Docker](https://docker.com/)** 

## Default settings

- TrackMania 2 Stadium
- 50 maximum players
- Time Attack game mode
- PyPlanet with default settings and apps

## Setting up

Copy the `vars.example.env` to `vars.env`, then put your IP address and your dedicated server
IDs (that you can create on your Maniaplanet player page).

## Adding maps

You need maps to run the server, put them in `Maps/My Maps/` and for each of them,
add this line at the end of `Maps/MatchSettings/match.xml` (right before the `</playlist>`) :
```xml
<map><file>May Maps/YourMap.Map.Gbx</file></map>
```

## Usage

First, edit the data/Config/server.xml values as you want. You can leave the default values,
but I would recommend changing at least the server name. 

Then, run using Docker Compose :
```bash
$ docker-compose up
```

To run it in background, add `-d` at the end. You can then use `docker logs (container ID)` to
get the logs (use `docker ps` to get the container ID).

## Restarting the server

```bash
$ docker-compose restart 
```