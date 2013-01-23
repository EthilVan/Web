require_relative 'helpers'

class ProfilTest < MiniTest::Spec

   def setup
      @profil = Profil.new
   end

   def test_birthdate_formatted_validation
      @profil.must_be_valid_with birthdate_formatted: ''
      @profil.must_be_valid_with birthdate_formatted: nil
      @profil.must_be_valid_with birthdate_formatted: '31/12/1986'
      @profil.wont_be_valid_with birthdate_formatted: '1999'
      @profil.wont_be_valid_with birthdate_formatted: '30/02/1975'
   end

   def test_sexe_validation
      @profil.must_be_valid_with sexe: ''
      @profil.must_be_valid_with sexe: 'masculin'
      @profil.must_be_valid_with sexe: 'feminin'
      @profil.wont_be_valid_with sexe: nil
      @profil.wont_be_valid_with sexe: 'hermaphrodite'
   end

=begin
   def test_favorite_block_validation
      @profil.wont_be_valid_with favorite_block: nil
      @profil.wont_be_valid_with favorite_block: Block::Names.size + 1
      @profil.must_be_valid_with favorite_block: 0
      @profil.must_be_valid_with favorite_block: Block::Names.size / 2
   end

   def test_favorite_item_validation
      @profil.wont_be_valid_with favorite_item: nil
      @profil.wont_be_valid_with favorite_item: Item::Names.size + 1
      @profil.must_be_valid_with favorite_item: 0
      @profil.must_be_valid_with favorite_item: Item::Names.size / 2
   end
=end
   def test_minecraft_since_validation
      text20 = '01234' * 4
      @profil.must_be_valid_with minecraft_since: text20
      @profil.wont_be_valid_with minecraft_since: nil
      @profil.wont_be_valid_with minecraft_since: text20[0..-2]
   end

   def test_website_validation
      @profil.must_be_valid_with website: 'http://google.com'
      @profil.must_be_valid_with website: nil
      @profil.wont_be_valid_with website: ''
      @profil.wont_be_valid_with website: 'notanurl'
      @profil.wont_be_valid_with website: 'git://notavalidurl.com'
   end

   def test_youtube_validation
      @profil.must_be_valid_with youtube: nil
      @profil.must_be_valid_with youtube: 'ac_count'
      @profil.must_be_valid_with youtube: 'Account-1337'
      @profil.wont_be_valid_with youtube: '2invalid'
      @profil.wont_be_valid_with youtube: '_invalid'
      @profil.wont_be_valid_with youtube: '-invalid'
   end

   def test_twitter_validation
      @profil.must_be_valid_with twitter: nil
      @profil.must_be_valid_with twitter: 'ac_count'
      @profil.must_be_valid_with twitter: 'Account-1337'
      @profil.wont_be_valid_with twitter: '2invalid'
      @profil.wont_be_valid_with twitter: '_invalid'
      @profil.wont_be_valid_with twitter: '-invalid'
   end

   def test_steam_id_validation
      @profil.must_be_valid_with steam_id: nil
      @profil.must_be_valid_with steam_id: 'ac_count'
      @profil.must_be_valid_with steam_id: 'Account-1337'
      @profil.wont_be_valid_with steam_id: '2invalid'
      @profil.wont_be_valid_with steam_id: '_invalid'
      @profil.wont_be_valid_with steam_id: '-invalid'
   end

   def test_custom_cadre_url
      @profil.must_be_valid_with custom_cadre_url: 'http://google.com'
      @profil.must_be_valid_with custom_cadre_url: nil
      @profil.wont_be_valid_with custom_cadre_url: ''
      @profil.wont_be_valid_with custom_cadre_url: 'notanurl'
      @profil.wont_be_valid_with custom_cadre_url: 'git://notavalidurl.com'
   end

   def test_age
      @profil.birthdate = 22.year.ago
      @profil.age.must_equal 22
   end
end
