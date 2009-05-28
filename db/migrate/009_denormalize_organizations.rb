class DenormalizeOrganizations < ActiveRecord::Migration
  def self.up
    # this does not preserve organization names, as it was written before that was necessary
    drop_table :organizations
    
    remove_column :users, :organization_id
    add_column :users, :organization_name, :string
    
    remove_column :campaigns, :organization_id
    add_column :campaigns, :creator_id, :integer
    add_index :campaigns, :creator_id
  end

  def self.down
    remove_column :campaigns, :creator_id
    add_column :campaigns, :organization_id, :integer
    add_index :campaigns, :organization_id
    
    remove_column :users, :organization_name
    add_column :users, :organization_id, :integer
    add_index :users, :organization_id
    
    create_table :organizations do |t|
      t.string :name
      t.timestamps
    end
  end
end