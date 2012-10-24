class CreateProfilTags < ActiveRecord::Migration
  def self.up
    create_table :profil_tags do |t|
      t.integer :tagger_id
      t.integer :tagged_id
      t.string :contents
    end
  end

  def self.down
    drop_table :profil_tags
  end
end
