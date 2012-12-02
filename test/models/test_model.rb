require_relative 'helpers'

class ModelTest < MiniTest::Spec

   def setup
      @account = FactoryGirl.build :account
   end

   def test_account
      @account.must_be_valid_with name: 'Abcdef'
   end
end
