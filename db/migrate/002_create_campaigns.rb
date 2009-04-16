class CreateCampaigns < ActiveRecord::Migration
  def self.up
    create_table :campaigns do |t|
      t.string :name, :keyword
      t.text :instructions, :description, :private_description, :template
      t.integer :points, :organization_id
      t.integer :runs, :default => 0
      t.timestamps
    end
    add_index :campaigns, :keyword
    add_index :campaigns, :organization_id
  end

  def self.down
    drop_table :campaigns
  end
end