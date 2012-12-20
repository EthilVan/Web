class EthilVan::App < Sinatra::Base

   get '/humans.txt' do
      content_type 'text/plain'
      view Views::Public::About.new
      layout false
      mustache 'public/humans'
   end

   get '/apropos' do
      view Views::Public::About.new
   mustache 'public/about'
   end
end
