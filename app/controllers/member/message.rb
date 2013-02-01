class EthilVan::App < Sinatra::Base

   get '/membre/message/:id' do |id|
      message = Message.find_by_id id
      raise Sinatra::NotFound if message.nil?
      page = message.page
      page = nil if page < 1
      redirect urls.discussion(message.discussion, page, message)
   end

   get '/membre/message/:id/editer' do |id|
      message = Message.find_by_id id
      raise Sinatra::NotFound if message.nil?
      not_authorized unless message.editable_by? current_account
      view Views::Member::Discussion::MessageForm.new(message)
      mustache 'membre/discussion/respond'
   end

   post '/membre/message/:id/editer' do |id|
      message = Message.find_by_id id
      raise Sinatra::NotFound if message.nil?
      not_authorized unless message.editable_by? current_account

      message.contents = params[:message]
      if message.save
         page = message.page
         page = nil if page < 1
         redirect urls.discussion(message.discussion, page, message)
      else
         view Views::Member::Discussion::MessageForm.new(message)
         mustache 'membre/discussion/respond'
      end
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
