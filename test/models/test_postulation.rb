require_relative 'helpers'

class PostulationTest < MiniTest::Spec

   def setup
      @postulation = Postulation.new
   end

   def test_name_validation
      @postulation.must_be_valid_with name: 'valid_name'
      @postulation.wont_be_valid_with name: nil
      @postulation.wont_be_valid_with name: '2djfsl'
      @postulation.wont_be_valid_with name: 'user'
      @postulation.wont_be_valid_with name: 'a'
   end

   def test_email_validation
      @postulation.must_be_valid_with email: 'email@example.com'
      @postulation.wont_be_valid_with email: nil
      @postulation.wont_be_valid_with email: ''
      @postulation.wont_be_valid_with email: 'notanemail'
      @postulation.wont_be_valid_with email: 'user@ethilvan.fr'
   end

   def test_minecraft_name_validation
      @postulation.must_be_valid_with minecraft_name: 'Test'
      @postulation.wont_be_valid_with minecraft_name: nil
      @postulation.wont_be_valid_with minecraft_name: ''
      @postulation.wont_be_valid_with minecraft_name: 'minecraft_user'
   end

   def test_password_validation
      @postulation.password_confirmation = 'test2'
      @postulation.wont_be_valid_with password: 'test'
      @postulation.must_be_valid_with password: 'test2'
   end

   def test_birthdate_formatted_validation
      @postulation.must_be_valid_with birthdate_formatted: nil
      @postulation.must_be_valid_with birthdate_formatted: ''
      @postulation.must_be_valid_with birthdate_formatted: '31/12/1986'
      @postulation.wont_be_valid_with birthdate_formatted: '1999'
      @postulation.wont_be_valid_with birthdate_formatted: '01/13/2004'
   end

   def test_sexe_validation
      @postulation.must_be_valid_with sexe: ''
      @postulation.must_be_valid_with sexe: 'masculin'
      @postulation.must_be_valid_with sexe: 'feminin'
      @postulation.wont_be_valid_with sexe: nil
      @postulation.wont_be_valid_with sexe: 'hermaphrodite'
   end

   def test_minecraft_since_validation
      @postulation.must_be_valid_with minecraft_since: <<-TEXT
         Je joue a minecraft depuis tres peu longtemps du tout, (nan je sais pas trop
         parler francais Lol mdr).
      TEXT
      @postulation.wont_be_valid_with minecraft_since: nil
      @postulation.wont_be_valid_with minecraft_since: 'a'
   end

   def test_ethilvan_discovered_validation
      @postulation.must_be_valid_with ethilvan_discovered: <<-TEXT
         J'ai decouvert EthilVan via la super chaine de TravisHironiak mon Er0 !
      TEXT
      @postulation.wont_be_valid_with ethilvan_discovered: nil
      @postulation.wont_be_valid_with ethilvan_discovered: 'a'
   end

   def test_ethilvan_reason_validation
      @postulation.must_be_valid_with ethilvan_reason: <<-TEXT
         J'ai choisi ethilvan parce que je suis fou amoureux de Loup, je l'aime je veux me
         marrier avec lui et qu'il me fasse des enfants'
      TEXT
      @postulation.wont_be_valid_with ethilvan_reason: nil
      @postulation.wont_be_valid_with ethilvan_reason: 'a'
   end

   def test_availability_validation
      @postulation.must_be_valid_with availability_schedule: <<-TEXT
         Je suis disponible tous les jours le matin le midi et l'apres midi, sauf le dimanche
         matin parce que le dimanche matin je vais a la messe, et le soir parce que je
         regarde plus belle la vie. Et apres a 19h48 je vais me coucher.
      TEXT
      @postulation.wont_be_valid_with availability_schedule: nil
      @postulation.wont_be_valid_with availability_schedule: 'a'
   end

   def test_rules_acceptation_validation
      @postulation.must_be_valid_with rules_acceptation: true
      @postulation.wont_be_valid_with rules_acceptation: false
   end
end
