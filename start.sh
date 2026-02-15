#!/bin/bash

echo "Démarrage Traefik..."
docker compose -f ~/projets/multiservice/traefik/docker-compose.yml up -d

sleep 5

docker compose -f ~/projets/multiservice/projet/docker-compose.yml up -d
docker compose -f ~/projets/multiservice/hello/docker-compose.yml up -d
docker compose -f ~/projets/multiservice/ha/docker-compose.yml up -d

echo "Stack Traefik et services démarrés avec succès !"
echo "Traefik Dashboard : http://traefik.localhost:8080"
echo "Tout est lancé !"
echo "hello : http://hello.localhost"
echo "ha : http://ha.localhost"
echo "projet : http://jellyfin.localhost"
echo "projet : http://qbittorrent.localhost"
echo "projet : http://prowlarr.localhost"
echo "projet : http://radarr.localhost"
echo "projet : http://sonarr.localhost"
echo "projet : http://lidarr.localhost"
echo "projet : http://readarr.localhost"
echo "projet : http://bazarr.localhost"

