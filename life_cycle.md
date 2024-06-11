# images docker

* nomenclature des images
* `docker pull IMAGE_NAME:([TAG_NAME]|[@sha26:HASH])`

# docker run: REMARQUES

* le processus lancé est indenpendant du PID du process du terminal (shell) qui a mancé le docker run => çà l'effet du namespace PID
* la redirection de sortie du docker run bloque le shell si le processus est un démon

* si l'image en paramètre du docker run n'est pas déjà sur l'instance du serveur docker,
  => alors le run va la télécharger


## sécurité des namespaces Linux

   * un host attaqué par un utilsateur malveillant aura la possibilité d'attaquer plus facilement les conteneurs qu'une vm à partir du moment ou l'attaquant peut trouver des élevation de privilèges vers les capacités du noyau
   => namespaces => conteneur => KO.
   * la problématique de la sécurisation est d'ABORD d'endurcir de l'environnement conteneur pour ne pas remonter dans le host 

## effet du namespace --pid

1. `docker run --name busy -it --rm busybox:stable`
   * voir les namespace enfants: `sudo ls -al /proc/$$/ns`
2. `ps -ef | grep bash`: => PID 1 dans le conteneur
3. `ctrl + p + q`: "sortir" du conteneur sans arrêter le process comme avec `exit`
4. `ps -ef | grep bash` : => PID xxxx dans le host
5. `docker attach test_ubu` pour "réentrer" dans le conteneur (et le processus contrôlé par le conteneur)  

* REMARQUE avec VSCODE le raccourci ctrl + P + Q est interpolé par des raccourcis vscode
* on peut gérer çà avec les settings utilisateur avec 
  1. ctrl + Shift + P (palette)
  2. renseigner settings et cliquer sur "paramètres utilisateur (JSON)"
  3. ajouter dans l'objet JSON
  ```json
   "terminal.integrated.commandsToSkipShell": [
      "-workbench.action.quickOpen",
      "-workbench.action.quickOpenView"
    ]
  ```

## effet du namespace "mnt" => mount => points de montages

* dans le conteneur on voit la racine et son i-node (donc emplacement dans le système de fochier de la machine hôte)
* si on veut comparer le numéro d'inode de "cette" racine avec la racine du hôte

```bash
docker exec <ctn_name> ls -ali /
ls -ali
```  
* les numéros sont !=
* le chemin du conteneur donné dans le système du hôtes est dans /var/lib/docker/overlay2/<image_hash>

* donc le namespace "mnt" du conteneur bloque l'accès à l'extérieur des processus dedans 

## notion d'idempotence

* "même puissance" => un processus exécuté doit donner le même état de fin
  => quelque soit le nombre d'exécution


## réseaux custom
 * BEST PRACTICE: on créé par défaut un réseau par microservice (app)


 ## conventions de docker compose

 * par défaut, le nom du réseau créé est <nom_du_dossier>_<clé_yaml>

