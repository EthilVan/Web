=begin
FactoryGirl.define do

   screens_url = [
      "http://ethilvan.fr/spout/item/PO.png",
      "http://ethilvan.fr/spout/item/PC.png",
      "http://ethilvan.fr/spout/cape/spm.png",
   ]

   sequence :postulation_screen_url do |n|
      screens_url[ (n-1) % 3 ]
   end

   factory :postulation_screen_valid, :class => PostulationScreen do
      url { FactoryGirl.generate(:postulation_screen_url) }
      description <<-END
         Voila ma super description de la mort qui tue, trop de la balle !!!!111
      END
   end

   factory :postulation do
      name "new_user"
      email "new_user@ethilvan.fr"
      minecraft_name "new_minecraft_user"
      password "password"
      password_confirmation "password"
      #minecraft_password "minecraft_password"
      birthdate_formatted "01/01/1998"
      sexe "feminin"
      minecraft_since <<-END
         Je joue a minecraft depuis tres peu longtemps du tout, (nan je sais pas trop
         parler francais Lol mdr).
      END
      multi_minecraft false


      ethilvan_discovered <<-END
         J'ai decouvert EthilVan via la super chaine de TravisHironiak mon Er0 !
      END

      ethilvan_reason <<-END
         J'ai choisi ethilvan parce que je suis fou amoureux de Loup, je l'aime je veux me
         marrier avec lui et qu'il me fasse des enfants'
      END

      availability_schedule <<-END
         Je suis disponible tous les jours le matin le midi et l'apres midi, sauf le dimanche
         matin parce que le dimanche matin je vais a la messe, et le soir parce que je
         regarde plus belle la vie. Et apres a 19h48 je vais me coucher.
      END
      microphone false

      rules_acceptation "1"

   end

   factory :postulation_with_multi_minecraft, :parent => :postulation do
      multi_minecraft true
      old_server <<-END
         Je jouais sur MineLittlePony.fr avant, c'etait un serveur super avec pleins de
         filles et meme qu'on faisait tout le temps des sculptures de poney en laines.
         C'etait trop bien.
      END
      old_server_reason <<-END
         Un jour un garcon a dessine une bite sur une de mes sculptures de poney, (je
         crois qu'il s'appelait EauTiste ou quelque chose comme ca). Du coup j'en ai eu
         marre donc je suis parti ='(.
      END
   end

   factory :postulation_with_microphone, :parent => :postulation do
      microphone true
      mumble { Postulation::Mumble.first }
   end

   factory :postulation_with_mumble_other, :parent => :postulation_with_microphone do
      mumble Postulation::Mumble.last
      mumble_other <<-END
         Je me connaitrais casiment tout le temps sauf quand H2O le sera parce qu'il
         me fais peur, j'ai l'impression qu'il veut me violer. En plus, j'ai vu sa photo sur
         le trombi et il a un regard de pervers =O.
      END
   end
end
=end
