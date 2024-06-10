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
