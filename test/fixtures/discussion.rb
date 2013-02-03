FactoryGirl.define do

   factory :discussion do

      ignore { messages_count 5 }

      name 'Discussion'

      messages do
         FactoryGirl.build_list(:message, messages_count)
      end
   end
end
