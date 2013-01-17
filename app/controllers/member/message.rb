class EthilVan::App < Sinatra::Base

   get '/membre/message/:id' do |id|
      message = Message.find_by_id id
      raise Sinatra::NotFound if message.nil?
      page = message.page
      page = nil if page < 1
      redirect urls.discussion(message.discussion, page, message)
   end
end
