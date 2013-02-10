require_relative 'helpers'

class AuthTest < DatabaseTest::Spec

   def test_login_is_accessible
      get '/login'
      response.must_be :ok?
   end

   def test_member_dons_is_not_accessible_when_not_logged
      get '/membre'
      response.must_be :redirecting_to_login?
   end

   def test_member_is_accessible_when_logged
      login 'user'
      get '/membre/dons'
      response.must_be :ok?
   end

   def test_news_index_does_not_display_private_news_when_not_logged_in
      get '/news'
      response.body.must_include parsed_summary :public
      response.body.must_include 'Private News'
      response.body.wont_include parsed_summary :private
   end

   def test_news_index_do_display_private_news_when_logged_in
      login 'user'
      get '/news'
      response.body.must_include parsed_summary :public
      response.body.must_include 'Private News'
      response.body.must_include parsed_summary :private
   end

   def test_news_creer_is_not_accessible_as_guest
      get '/news/creer'
      response.must_be :redirecting_to_login?
   end

   def test_news_creer_is_not_accessible_for_default_user
      login 'user'
      get '/news/creer'
      response.must_be :not_authorized?
   end

   def test_news_creer_is_accessible_for_redacteur
      login 'redacteur'
      get '/news/creer'
      response.must_be :ok?
   end

   def test_news_editer_is_not_accessible_as_guest
      get "/news/#{News.first.id}/editer"
      response.must_be :redirecting_to_login?
   end

   def test_news_editer_is_not_accessible_for_default_user
      login 'user'
      get "/news/#{News.first.id}/editer"
      response.must_be :not_authorized?
   end

   def test_news_editer_is_accessible_for_redacteur
      login 'redacteur'
      get "/news/#{News.first.id}/editer"
      response.must_be :ok?
   end

   def test_news_supprimer_is_not_accessible_as_guest
      get "/news/#{News.first.id}/supprimer"
      response.must_be :redirecting_to_login?
   end

   def test_news_supprimer_is_not_accessible_for_default_user
      login 'user'
      get "/news/#{News.first.id}/supprimer"
      response.must_be :not_authorized?
   end

   def test_news_supprimer_is_accessible_for_redacteur
      login 'redacteur'
      get "/news/#{News.first.id}/supprimer"
      response.wont_be :redirecting_to_login?
      response.wont_be :not_authorized?
   end

private

   def parsed_summary(private)
      News.where(private: private == :private).first.parsed_summary
   end
end
