Dir["test/fixtures/*.rb"].each do |factory|
   require './' + factory.gsub(/\.rb$/, "")
end

FactoryGirl.create :account
redacteur = FactoryGirl.create :redacteur
FactoryGirl.create :modo
FactoryGirl.create :news, account_id: redacteur.id
FactoryGirl.create :private_news, account_id: redacteur.id
