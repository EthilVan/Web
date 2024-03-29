FactoryGirl.define do

   factory :news do
      title 'News'
      summary 'Summary of this awesome news !!!'
      contents <<-CONTENTS
Here's come an awesome news (shorter than the summary, come on!)
(Well now it's longer, kthxbye)
CONTENTS
      important false
      private false
   end

   factory :private_news, parent: :news do
      title 'Private News'
      summary <<-CONTENTS
Here's come an awesome private news for super VIP only !!
CONTENTS
      private true
   end
end

