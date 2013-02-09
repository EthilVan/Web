class EthilVan::App < Sinatra::Base

   helpers do

      def discussion_url(message, discussion = message.discussion, page = nil)
         page ||= message.page
         page = nil if page < 1
         urls.discussion(message.discussion, page, message)
      end
   end

   get '/membre/message/:id' do |id|
      message = Message.find_by_id id
      raise Sinatra::NotFound if message.nil?
      redirect discussion_url message
   end

   get %r{/membre/discussion/(\d{1,5})/repondre$} do |id|
      discussion = Discussion.find_by_id id
      raise Sinatra::NotFound if discussion.nil?

      message = Message.new
      message.discussion = discussion
      message.account = current_account

      url = request.xhr? ? request.path : ''
      view Views::Member::Message::Create.new message, request.xhr?, url
      layout !request.xhr?
      mustache 'membre/message/create'
   end

   post %r{/membre/discussion/(\d{1,5})/repondre$} do |id|
      discussion = Discussion.find_by_id id
      raise Sinatra::NotFound if discussion.nil?

      message = Message.new params[:message]
      message.discussion = discussion
      message.account = current_account

      if message.save
         if request.xhr?
            layout false
            view Views::Member::Discussion::Response.new discussion, message, true
            mustache 'membre/discussion/_response'
         else
            redirect urls.discussion(discussion, discussion.total_pages, message)
         end
      else
         view Views::Member::Message::Create.new message
         mustache 'membre/message/create'
      end
   end

   get '/membre/message/:id/editer' do |id|
      message = Message.find_by_id id
      raise Sinatra::NotFound if message.nil?
      not_authorized unless message.editable_by? current_account

      url = request.xhr? ? request.path : ''
      view Views::Member::Message::Edit.new message, request.xhr?, url
      layout !request.xhr?
      mustache 'membre/message/edit'
   end

   post '/membre/message/:id/editer' do |id|
      message = Message.find_by_id id
      raise Sinatra::NotFound if message.nil?
      not_authorized unless message.editable_by? current_account

      if message.update_attributes params[:message]
         if request.xhr?
            layout false
            view Views::Member::Discussion::Message.new message, true
            mustache 'membre/discussion/_message'
         else
            redirect discussion_url message
         end
      else
         view Views::Member::Message::Edit.new message
         mustache 'membre/message/edit'
      end
   end

   get '/membre/message/:id/supprimer' do |id|
      message = Message.find_by_id id
      raise Sinatra::NotFound if message.nil?
      raise Sinatra::NotFound if message.first_message?
      not_authorized unless message.editable_by? current_account

      following = message.following
      message.destroy
      halt(200) if request.xhr?
      redirect urls.discussion(message.discussion, following.page,following)
   end
end
