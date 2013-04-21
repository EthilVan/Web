class EthilVan::App < Sinatra::Base

   logged_only %r{^/markdown(?:$|/)}

   post '/markdown/?' do
      markdown params['content']
   end

   get '/markdown/membres.json' do
      names = Account.where("role_id != 'ancien'").pluck(:name)

      content_type 'application/json'
      json = '['
      unless names.empty?
         json << "\""
         json << names * "\",\""
         json << "\""
      end
      json << ']'
      json
   end

   get '/markdown/editeur' do
      view Views::Public::MarkdownEditor.new
      mustache 'public/markdown_editor'
   end
end
