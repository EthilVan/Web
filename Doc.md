## Installation

### Windows

#### [JRuby][jruby]
Utiliser l'installateur approprié : [JRuby Downloads][jruby_download]

Il est aussi nécessaire d'installer Bundler. Pour cela, dans une console :

`jruby -S gem install bundler`


#### [Node.js][node]
[Node.js][node] est nécessaire pour la compilation des assets (css avec
less et javascript avec typescript). Utiliser l'installateur disponible
[ici][node_download].

Une fois installé, dans une console taper :

`npm install -g less typescript`


#### Configuration

Le site web utilise un fichier de configuration `config/config.yml` pour
gérer sa configuration (notamment pour les informations de connexion à
la base de données).

Se réferer au fichier `config/config.example.yml` pour plus de détails.



## Utilisation

Note : Les commandes ci-dessous assument que vous vous trouver dans
le dossier du projet.

Note 2 : Les commandes ci-dessous utilisent des programmes ruby.
Avec jruby il est necéssaire de prefixer les commandes avec `jruby -S `.
Il est expliqué dans une section plus bas comment éviter d'avoir à utiliser
ce préfixe à chaque fois.

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

Pour supprimer tout ce qui a été généré de manière automatique pour les
assets (cache et fichiers résultants) afin de répartir sur une base fraiche :

`rake assets:clean`


### Accéder au site web
Afin de pouvoir accéder au site web via votre navigateur, il est
nécessaire d'utiliser un serveur de développement.
Pour jruby le serveur recommandé est puma.
Installable grâce à la commande :

`jruby -S gem install puma`

Une fois installé pour le lancer :

`jruby -s puma`

L'addresse d'accés sera affiché dans la console.
(en générale http://localhost:9292 pour puma)



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
* **Mustache** ([Lien Github][mustacthe] pas de package avec PackageControl) :
  Coloration syntaxique pour les fichiers mustache.


### Console

#### Alias :

Il est possible de définir des alias dans le fichier ".bashrc"
(qui se trouve dans le dossier personnel) ce qui peut être très pratique
pour raccourcir des commandes très utilisés et longues.

Exemples :

* `alias bundle="jruby -S bundle install"`
* `alias rake="jruby -S rake"`
* `alias assets="jruby -S rake assets:compile"`
* `alias watch="jruby -S rake assets:watch"`
* `alias puma="jruby -S puma"`


[jruby]: http://jruby.org/
[jruby_download]: http://jruby.org/download
[node]: http://nodejs.org/
[node_download]: http://nodejs.org/download
[bundler]: http://gembundler.com/
[rake]: http://rake.rubyforge.org/
[sublimetext2]: http://sublimetext.com/2
[packagecontrol]: http://wbond.net/sublime_packages/package_control/installation
[mustacthe]: https://github.com/defunkt/Mustache.tmbundle
