FactoryGirl.define do

   factory :message do

      account { Account.first }

      contents 'Message !'
   end
end
