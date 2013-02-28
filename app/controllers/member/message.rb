class EthilVan::App < Sinatra::Base

   helpers do

      def discussion_url(message, discussion = message.discussion, page = nil)
         page ||= message.page
         page = nil if page < 1
         urls.discussion(message.discussion, page, message)
      end

      def new_messages(discussion, last_message_id)
         return [] if last_message_id.nil? or
               discussion.last_message.id == last_message_id

         messages = discussion.messages
         index = messages.index { |msg| msg.id == last_message_id }
         return [] if index.nil?
         messages[(index + 1)..-1]
      end
   end

   get '/membre/message/:id' do |id|
      message = resource Message.find_by_id id
      redirect discussion_url message
   end

   get %r{/membre/discussion/(\d{1,5})/repondre(?:/(\d{1,7}))?$} do |id, last_message|
      discussion = resource Discussion.find_by_id id
      not_authorized if !modo? and discussion.archived?
      new_messages = []
      if inline = !!last_message && xhr?
         new_messages = new_messages(discussion, last_message.to_i)
      end

      message = Message.new
      message.discussion = discussion
      message.account = current_account

      view Views::Member::Message::Create.new new_messages, message, inline
      mustache 'membre/message/create'
   end

   post %r{/membre/discussion/(\d{1,5})/repondre(?:/(\d{1,7}))?$} do |id, last_message|
      discussion = resource Discussion.find_by_id id
      not_authorized if !modo? and discussion.archived?
      new_messages = []
      inline = !!last_message && xhr?

      message = Message.new params[:message]
      message.discussion = discussion
      message.account = current_account

      if message.save
         DiscussionView.update_for(current_account, discussion, Time.now + 1)
         redirect_not_xhr urls.discussion(discussion,
               discussion.total_pages, message)
         new_messages = new_messages(discussion, last_message.to_i)
         view Views::Member::Discussion::Response.new discussion, new_messages
         mustache 'membre/discussion/_response'
      else
         new_messages = new_messages(discussion, last_message.to_i) if inline
         view Views::Member::Message::Create.new new_messages, message, inline
         mustache 'membre/message/create'
      end
   end

   get '/membre/message/:id/editer' do |id|
      message = resource Message.find_by_id id
      not_authorized unless message.editable_by? current_account

      view Views::Member::Message::Edit.new message, xhr?, request.path
      mustache 'membre/message/edit'
   end

   post '/membre/message/:id/editer' do |id|
      message = resource Message.find_by_id id
      not_authorized unless message.editable_by? current_account

      if message.update_attributes params[:message]
         redirect_not_xhr discussion_url message
         view Views::Member::Discussion::Message.new message, true
         mustache 'membre/discussion/_message'
      else
         view Views::Member::Message::Edit.new message, xhr?, request.path
         mustache 'membre/message/edit'
      end
   end

   get '/membre/message/:id/supprimer' do |id|
      message = resource Message.find_by_id id
      not_found if message.first_message?
      not_authorized unless message.editable_by? current_account

      following = message.following
      message.destroy
      xhr_ok_or_redirect urls.discussion(message.discussion,
            following.page, following)
   end
end
