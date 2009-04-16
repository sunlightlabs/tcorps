class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :organization_id
      t.boolean :admin
      t.string :api_key
      t.timestamps
      
      # authlogic fields
      t.string    :login,               :null => false
      t.string    :crypted_password,    :null => false
      t.string    :password_salt,       :null => false
      t.string    :persistence_token,   :null => false
    end
    
    add_index :users, :login
    add_index :users, :persistence_token
    add_index :users, :api_key
    add_index :users, :organization_id
  end

  def self.down
    drop_table :users
  end
end