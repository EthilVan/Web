class EthilVan::App < Sinatra::Base

   get '/membre/message/:id' do |id|
      message = Message.find_by_id id
      raise Sinatra::NotFound if message.nil?
      page = message.page
      page = nil if page < 1
      redirect urls.discussion(message.discussion, page, message)
   end

   get '/membre/message/:id/supprimer' do |id|
      message = Message.find_by_id id
      raise Sinatra::NotFound if message.nil?
      not_authorized unless message.editable_by? current_account
      following = message.following
      message.destroy
      redirect urls.discussion(message.discussion, following.page, following)
   end
end
