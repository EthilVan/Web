require_relative 'helpers'

class AuthTest < MiniTest::Spec

   def setup
      @account = FactoryGirl.create :account
      @news = FactoryGirl.create :news, account_id: @account.id
      @private_news = FactoryGirl.create :private_news,
            account_id: @account.id, title: "Private News"
   end

   def teardown
      Account.truncate
      News.truncate
   end

   def test_presentation_is_accessible
      get '/presentation'
      follow_redirect!
      response.must_be :ok?
   end

   def test_member_is_not_accessible_when_not_logged
      get '/membre'
      response.wont_be :ok?
   end

   def test_member_is_accessible_when_logged
      login @account
      get '/membre'
      follow_redirect!
      response.must_be :ok?
   end
end
