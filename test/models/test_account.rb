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

   def test_password_is_valid_when_absent_and_when_account_has_already_a_password
      @account.password = nil
      @account.password_confirmation = nil
      @account.crypted_password = "djhflkjf"

      @account.must_be_valid :password
   end

   def test_password_is_invalid_when_absent_and_when_account_has_not_already_a_password
      @account.password = nil
      @account.password_confirmation = nil
      @account.crypted_password = nil

      @account.wont_be_valid :password
   end

   def test_password_is_valid_when_confirmation_is_equal
      @account.password = "test"
      @account.password_confirmation = "test2"
      @account.wont_be_valid :password

      @account.password_confirmation = "test"
      @account.must_be_valid :password
   end
end
