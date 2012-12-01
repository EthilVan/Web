class EthilVan::App

   get '/membre/liste' do
      members = Account.all
      current, old = members.partition do |member|
         member.role.inherit?(EthilVan::Role::MEMBER)
      end
      view Views::Member::List.new(current, old)
      mustache 'member/list'
   end
end
