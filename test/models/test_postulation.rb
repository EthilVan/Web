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

   def test_rules_acceptance_validation
      @postulation.must_be_valid_with rules_acceptance: '1'
      @postulation.wont_be_valid_with rules_acceptance: nil
      @postulation.wont_be_valid_with rules_acceptance: ''
      @postulation.wont_be_valid_with rules_acceptance: '0'
   end

   def test_old_server_validation_without_multi_minecraft
      @postulation.multi_minecraft = false
      @postulation.must_be_valid_with old_server: <<-TEXT
         Je jouais sur MineLittlePony.fr avant, c'etait un serveur super avec pleins de
         filles et meme qu'on faisait tout le temps des sculptures de poney en laines.
         C'etait trop bien.
      TEXT
      @postulation.must_be_valid_with old_server: nil
      @postulation.must_be_valid_with old_server: 'a'
   end

   def test_old_server_validation_with_multi_minecraft
      @postulation.multi_minecraft = true
      @postulation.must_be_valid_with old_server: <<-TEXT
         Je jouais sur MineLittlePony.fr avant, c'etait un serveur super avec pleins de
         filles et meme qu'on faisait tout le temps des sculptures de poney en laines.
         C'etait trop bien.
      TEXT
      @postulation.wont_be_valid_with old_server: nil
      @postulation.wont_be_valid_with old_server: 'a'
   end

   def test_old_server_reason_validation_without_multi_minecraft
      @postulation.multi_minecraft = false
      @postulation.must_be_valid_with old_server_reason: <<-TEXT
         Un jour un garcon a dessine une bite sur une de mes sculptures de poney, (je
         crois qu'il s'appelait EauTiste ou quelque chose comme ca). Du coup j'en ai eu
         marre donc je suis parti ='(.
      TEXT
      @postulation.must_be_valid_with old_server_reason: nil
      @postulation.must_be_valid_with old_server_reason: 'a'
   end

   def test_old_server_reason_validation_with_multi_minecraft
      @postulation.multi_minecraft = true
      @postulation.must_be_valid_with old_server_reason: <<-TEXT
         Un jour un garcon a dessine une bite sur une de mes sculptures de poney, (je
         crois qu'il s'appelait EauTiste ou quelque chose comme ca). Du coup j'en ai eu
         marre donc je suis parti ='(.
      TEXT
      @postulation.wont_be_valid_with old_server_reason: nil
      @postulation.wont_be_valid_with old_server_reason: 'a'
   end

   def test_mumble_validation_without_microphone
      @postulation.microphone = false
      @postulation.must_be_valid_with mumble: EthilVan::Data::Mumble.first
      @postulation.must_be_valid_with mumble: nil
      @postulation.must_be_valid_with mumble: 'a'
   end

   def test_mumble_validation_with_microphone
      @postulation.microphone = true
      @postulation.must_be_valid_with mumble: EthilVan::Data::Mumble.first
      @postulation.wont_be_valid_with mumble: nil
      @postulation.wont_be_valid_with mumble: 'a'
   end

   def test_mumble_other_validation_without_mumble_other
      @postulation.microphone = true
      @postulation.mumble = EthilVan::Data::Mumble.first
      @postulation.must_be_valid_with mumble_other: <<-TEXT
         Je me connaitrais casiment tout le temps sauf quand H2O le sera parce qu'il
         me fais peur, j'ai l'impression qu'il veut me violer. En plus, j'ai vu sa photo sur
         le trombi et il a un regard de pervers =O.
      TEXT
      @postulation.must_be_valid_with mumble_other: nil
      @postulation.must_be_valid_with mumble_other: 'a'
   end

   def test_mumble_other_validation_with_mumble_other
      @postulation.microphone = true
      @postulation.mumble = EthilVan::Data::Mumble.last
      @postulation.must_be_valid_with mumble_other: <<-TEXT
         Je me connaitrais casiment tout le temps sauf quand H2O le sera parce qu'il
         me fais peur, j'ai l'impression qu'il veut me violer. En plus, j'ai vu sa photo sur
         le trombi et il a un regard de pervers =O.
      TEXT
      @postulation.wont_be_valid_with mumble_other: nil
      @postulation.wont_be_valid_with mumble_other: 'a'
   end
end
