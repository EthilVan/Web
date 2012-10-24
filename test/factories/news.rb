FactoryGirl.define do

   factory :new do
      title "News"
      contents "Here's come an awesome news"
      important false
      private false
   end

   factory :private_new, :parent => :new do
      private true
   end
end
