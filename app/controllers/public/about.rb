class EthilVan::App < Sinatra::Base

   get '/apropos' do
      view Views::Public::About.new
      mustache 'public/about/index'
   end

   get '/humans.txt' do
      content_type 'text/plain'
      view Views::Public::About.new
      layout false
      mustache 'public/about/humans'
   end
end
