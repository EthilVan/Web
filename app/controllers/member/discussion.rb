class EthilVan::App < Sinatra::Base

   get '/membre/discussion' do
      view Views::Page.new
      mustache 'member/discussion/index'
   end
end
