require_relative 'helpers'

class ContactTest < MiniTest::Spec

   def setup
      @contact = ContactEmail.new
   end

   def test_name_validation
      @contact.must_be_valid_with name: 'name'
      @contact.wont_be_valid_with name: nil
      @contact.wont_be_valid_with name: ''
      @contact.wont_be_valid_with name: '2startwithanumber'
   end

   def test_email_validation
      @contact.must_be_valid_with email: 'contact@example.com'
      @contact.wont_be_valid_with email: nil
      @contact.wont_be_valid_with email: ''
      @contact.wont_be_valid_with email: 'notanemail'
      @contact.wont_be_valid_with email: 'not@nemail'
   end

   def test_subject_validation
      @contact.must_be_valid_with subject: 'Subject'
      @contact.wont_be_valid_with subject: nil
      @contact.wont_be_valid_with subject: ''
   end

   def test_category_validation
      ContactEmail::CATEGORIES.each do |category|
         @contact.must_be_valid_with category: category
      end
      @contact.wont_be_valid_with category: nil
      @contact.wont_be_valid_with category: ''
      @contact.wont_be_valid_with category: 'notacategory'
   end

   def test_message_validation
      @contact.must_be_valid_with message: 'Message !'
      @contact.wont_be_valid_with message: nil
      @contact.wont_be_valid_with message: ''
   end

   def test_sender
      @contact.name = 'Sender'
      @contact.email = 'sender@example.com'

      @contact.sender.must_equal 'Sender <sender@example.com>'
   end

   def test_categorized_subject
      @contact.category = 'general'
      @contact.subject = 'Subject'

      @contact.categorized_subject.must_equal '[general] Subject'
   end

   def test_body
      @contact.name = 'Sender'
      @contact.email = 'sender@example.com'
      @contact.category = 'general'
      @contact.subject = 'Subject'
      @contact.message = 'Message !'

      body = @contact.body
      body.must_match /Sender/
      body.must_match /sender@example.com/
      body.must_match /general/
      body.must_match /Subject/
      body.must_match /Message !/
   end
end
