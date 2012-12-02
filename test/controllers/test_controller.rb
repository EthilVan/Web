require_relative 'helpers'

class ControllerTest < MiniTest::Spec

   def test_presentation
      get '/'
      follow_redirect!

      response.must_be :ok?
   end
end
