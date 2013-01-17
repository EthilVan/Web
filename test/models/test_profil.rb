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

   def test_age
      @profil.birthdate = 22.year.ago
      @profil.age.must_equal 22
   end
end
