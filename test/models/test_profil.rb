require_relative 'helpers'

class ProfilTest < MiniTest::Spec

   def setup
      @profil = Profil.new
   end

   def test_birthdate_formatted_validation
      @profil.wont_be_valid_with birthdate_formatted: '1999'
      @profil.wont_be_valid_with birthdate_formatted: '30/02/1975'

      @profil.must_be_valid_with birthdate_formatted: ''
      @profil.must_be_valid_with birthdate_formatted: nil
      @profil.must_be_valid_with birthdate_formatted: '31/12/1986'
   end

   def test_sexe_validation
      @profil.wont_be_valid_with sexe: nil
      @profil.wont_be_valid_with sexe: 'hermaphrodite'
      @profil.must_be_valid_with sexe: ''
      @profil.must_be_valid_with sexe: 'masculin'
      @profil.must_be_valid_with sexe: 'feminin'
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

   def test_age
      @profil.birthdate = 22.year.ago
      @profil.age.must_equal 22
   end
end
