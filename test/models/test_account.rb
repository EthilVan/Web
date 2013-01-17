require_relative 'helpers'

class AccountTest < MiniTest::Spec

   def setup
      @account = Account.new
   end

   def test_name_validation
      @account.must_be_valid_with name: 'valid'
      @account.wont_be_valid_with name: nil
      @account.wont_be_valid_with name: '2djfsl'
      @account.wont_be_valid_with name: 'a'
   end

   def test_email_validation
      @account.must_be_valid_with email: 'address@example.com'
      @account.wont_be_valid_with email: nil
      @account.wont_be_valid_with email: ''
      @account.wont_be_valid_with email: 'notanemail'
   end
end
