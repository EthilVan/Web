class EthilVan::App

   get '/membre/liste' do
      current, old = Account.with_profil.partition do |member|
         member.role.inherit?(EthilVan::Role::MEMBER)
      end
      view Views::Member::List.new(current, old)
      mustache 'membre/membres/list'
   end
end
