FactoryGirl.define do

   factory :account do
      name "user"
      email "user@ethilvan.fr"
      password "password"
      password_confirmation "password"
      minecraft_name "minecraft_user"
      role "default"
   end

   factory :redacteur, parent: :account do
      name "redacteur"
      email "redacteur@ethilvan.fr"
      minecraft_name "minecraft_redacteur"
      role "redacteur"
   end

   factory :modo, parent: :account do
      name "modo"
      email "modo@ethilvan.fr"
      minecraft_name "minecraft_modo"
      role "modo"
   end

   factory :dev, parent: :account do
      name "dev"
      email "dev@ethilvan.fr"
      minecraft_name "minecraft_dev"
      role "dev"
   end

   factory :admin, parent: :account do
      name "admin"
      email "admin@ethilvan.fr"
      minecraft_name "minecraft_admin"
      role "admin"
   end
end
