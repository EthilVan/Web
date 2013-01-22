Dir["test/fixtures/*.rb"].each do |factory|
   require './' + factory.gsub(/\.rb$/, "")
end

# Accounts
FactoryGirl.create :account
redacteur = FactoryGirl.create :redacteur
FactoryGirl.create :modo

# News
FactoryGirl.create :news, account_id: redacteur.id
FactoryGirl.create :private_news, account_id: redacteur.id

# Postulation
FactoryGirl.create :postulation
