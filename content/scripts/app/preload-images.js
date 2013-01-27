/// <reference path="../definitions/jquery.d.ts" />

this.cache = [];

function preloadImages(images) {
   for (var i = 0; i < images.length; i++) {
      var img = $('<img src="/images/layout/'+ images[i] + '" />');
      this.cache.push(img);
   }
}

preloadImages([
   'bouton-serveur.png',
   'bouton-serveur-2.png',
   'bouton-connexion.png',
   'bouton-connexion-2.png',
   'bouton-membre.png',
   'bouton-membre-2.png',

   'membre/accueil.png',
   'membre/accueil-2.png',
   'membre/discussions.png',
   'membre/discussions-2.png',
   'membre/projets.png',
   'membre/projets-2.png',
   'membre/evenements.png',
   'membre/evenements-2.png',
   'membre/profil.png',
   'membre/profil-2.png',
   'membre/membres.png',
   'membre/membres-2.png',
   'membre/don.png',
   'membre/don-2.png',

   'serveur/presentation.png',
   'serveur/presentation-2.png',
   'serveur/apercu.png',
   'serveur/apercu-2.png',
   'serveur/news.png',
   'serveur/news-2.png',
   'serveur/reglement.png',
   'serveur/reglement-2.png',
   'serveur/postulation.png',
   'serveur/postulation-2.png',
   'serveur/aide.png',
   'serveur/aide-2.png',
   'serveur/contact.png',
   'serveur/contact-2.png'
]);
