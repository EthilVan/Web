FactoryGirl.define do

   factory :profil do
      minecraft_since <<-END
         Je joue a minecraft depuis tres peu longtemps du tout, (nan je sais pas trop
         parler francais Lol mdr).
      END
      favorite_block 1
      favorite_item 1
      skill <<-END
         Je suis trop fort en tout. Rien ne me fait peur, je suis un winner !
         Je suis
      END
      desc_rp <<-END
         Je suis Roland de Troyes, vous connaissez peut etre quelques histoires
            a propos de moi. La chanson de Roland ou un truc du enre vous connaissez.
      END

      birthdate_formatted "23/12/1970"
      sexe "feminin"
      localisation "Troyes, pardi"

      website "roland-de-troyes.fr"
      twitter "roland-de-troyes"
      youtube "rolandDeTroyes"
      description <<-END
         Je suis un big boss a l'epee, des creepers j'en bouffe 5 au dejeuner, je leur mets leur r***.
      END
    end
end
