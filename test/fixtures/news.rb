FactoryGirl.define do

   factory :news do
      title 'News'
      contents 'Here\'s come an awesome news'
      important false
      private false
   end

   factory :private_news, parent: :news do
      title 'Private News'
      private true
   end
end

