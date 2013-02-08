## Installation

#### Configuration

Le site web utilise un fichier de configuration `config.yml` pour
gérer sa configuration (notamment pour les informations de connexion à
la base de données).

Exemple :

```yml
database:
   development:
      username:  username
      password:  password
      database:  database
```


## Utilisation

Note : Les commandes ci-dessous assument que vous vous trouver dans
le dossier du projet.

### Dépendances

Le site web utilise [bundler][bundler] pour gérer ses dépendances de
manière simple.
Installer / mettre à jour les dépendances se résume à un :

`bundle install`

Déterminer si de nouveau commits implique des modifications au niveau
des dépendances (et donc nécessitent un bundle install) est aussi simple que
de vérifier si le fichier Gemfile a été modifié.
En cas de doute, lancer la commande ne peut pas faire de mal.

### [Rake][rake]

Toutes les tâches automatisées ci-dessous sont prises en charge par le
programme ruby [rake][rake]. (Rake est une dépendance d'ethilvanfr donc il
doit déjà être installé si vous avez suivi l'étape du dessus)


### Base de données

Afin de créer/mettre à jour/etc.. les différentes tables nécessaires,
ethilvanfr utilise un système dit de migrations. Chaque migration est
défini dans un fichier prefixé par un numéro dans le dossier
`database/migrations` qui décrit les modifications à effectuer
(dans les deux sens : pour effectuer la migration à proprement parlé ou
pour l'annuler).

Un nouveau fichier dans ce dossier indique donc qu'il est necéssaire
d'effectuer une mise à jour de la base de données.
Pour ceci :

`rake db:migrate`


### Assets

#### Emoji

Les emojis ne sont pas directement integré au dépôts. Pour les installer,
il suffit de taper:

`rake assets:install`


#### Style et Javascript

Que ce soit les stylesheets ou les scripts Javascript, ils nécessitent tous
deux une phase de compilation afin d'être disponible pour votre navigateur.

##### Compilation directe

Pour lancer une compilation directe des fichiers css/js,
utiliser la commande :

```
rake assets[:compile]
# ou encore:
rake assets:compile:script
rake assets:compile:style
```

##### Compilation interactive

La compilation interactive utilise un programme qui va tourner en continue
et surveiller les modifications effectuées au fichiers sources afin de
recompiler quand cela est nécessaire. Pour le lancer :

`rake assets:watch`


#### Clean des assets:

Pour supprimer tout ce qui a pu être généré de manière automatique pour les
assets (cache et/ou fichiers résultants) afin de répartir sur une base fraiche :

```
rake assets:clean
rake assets:clean:cache
rake assets:clean:emoji
rake assets:clean:style
rake assets:clean:script
```


### Accéder au site web

Afin de pouvoir accéder au site web via votre navigateur, il est
nécessaire d'utiliser un serveur de développement.
La commande pour le lancer :

```
rackup
```

Le site est ensuite accessible en utilisant l'url http://localhost:9180


## Tricks

### [Sublime Text 2][sublimetext2]
L'utilisation de [Sublime Text 2][sublimetext2] avec
[PackageControl][packagecontrol] pour l'édition est fortement recommandé.

Quelques packages utiles :

* **Auto Encoding For Ruby** :
  Gestion automatique de l'encoding des fichiers ruby
* **EditorConfig** :
  Permet l'utilisation automatique des propriétés de formattage des fichiers
  (tabulation/espace / fin de ligne, etc) défini par le fichier .editorconfig
* **Modific** :
  Signale les lignes modifiés depuis le dernier commit.
* **LESS** :
  Coloration syntaxique pour les fichiers less.
* **Mustache** ([Lien Github][mustache] pas de package avec PackageControl) :
  Coloration syntaxique pour les fichiers mustache.


### Console

#### Alias :

Il est possible de définir des alias dans le fichier ".bashrc"
(qui se trouve dans le dossier personnel) ce qui peut être très pratique
pour raccourcir des commandes très utilisés et longues.

Exemples :

* `alias watch="rake assets:watch"`
* `alias s="rackup"`


[bundler]: http://gembundler.com/
[rake]: http://rake.rubyforge.org/
[sublimetext2]: http://sublimetext.com/2
[packagecontrol]: http://wbond.net/sublime_packages/package_control/installation
[mustache]: https://github.com/defunkt/Mustache.tmbundle
