# Projet Docker & Architecture de services

Ce projet met en place une architecture de services conteneurisés derrière un reverse proxy (Traefik).

## Comment lancer le projet

Le projet s'appuie sur un script d'automatisation pour gérer les réseaux, les permissions et le démarrage des conteneurs.

**Prérequis :**
* Docker et Docker Compose installés.
* Ports 80 et 8080 disponibles.

**Démarrage :**
À la racine du projet, exécutez simplement :

```bash
# Rend le script exécutable (si nécessaire)
chmod +x start.sh

# Lance l'installation et le démarrage
./start.sh
```


## Détail du Site 3 : Netflix Maison

Ce service est une **stack multimédia complète et automatisée**. Elle permet la gestion, le téléchargement et la diffusion de contenus (vidéos, musiques, livres) via une interface unifiée.

### Architecture des micro-services
L'application repose sur l'orchestration de 8 conteneurs interconnectés :

* **Diffusion & Interface :**
    * `Jellyfin` : Serveur média (le "Netflix" accessible par l'utilisateur).
* **Gestionnaires de collection (Suite *Arr) :**
    * `Radarr` : Gestion automatisée des films.
    * `Sonarr` : Gestion automatisée des séries TV.
    * `Lidarr` : Gestion de la musique.
    * `Readarr` : Gestion des livres et ebooks.
    * `Bazarr` : Gestion et synchronisation des sous-titres.
* **Infrastructure de téléchargement :**
    * `Prowlarr` : Gestionnaire d'indexeurs (fait le pont entre les sites de torrents et les apps *Arr).
    * `qBittorrent` : Client de téléchargement.

### Fonctionnement (Workflow)
Les services fonctionnent en synergie via le réseau Docker interne :
1.  L'utilisateur ajoute un média souhaité dans l'application dédiée (ex: un film dans **Radarr**).
2.  L'application interroge **Prowlarr** pour trouver le fichier via les indexeurs configurés.
3.  L'ordre de téléchargement est envoyé à **qBittorrent**.
4.  Une fois le téléchargement terminé dans `data/downloads`, l'application (Radarr/Sonarr/etc.) importe, renomme et déplace le fichier final dans le dossier média correspondant (`data/movies`, etc.).
5.  **Jellyfin** scanne ces dossiers et rend le contenu disponible au streaming immédiatement.

### Stockage et Persistance
Toutes les données sont stockées de manière persistante sur l'hôte via des volumes Docker (Bind mounts), situés dans le dossier `./data` :

* `data/configs/` : Contient la configuration individuelle de chaque service (base de données, préférences).
* `data/downloads/` : Zone tampon pour les téléchargements en cours.
* `data/movies/`, `data/shows/`, `data/music/`, `data/books/` : Stockage final des médias organisés, lus par Jellyfin.