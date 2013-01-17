require_relative 'helpers'

class AccountTest < MiniTest::Spec

   def setup
      @account = FactoryGirl.build :account
   end

   def test_name_validation
      @account.wont_be_valid_with name: nil
      @account.wont_be_valid_with name: "2djfsl"
      @account.wont_be_valid_with name: "a"
      @account.wont_be_valid_with name: "profil"
      @account.must_be_valid_with :name
   end
end
