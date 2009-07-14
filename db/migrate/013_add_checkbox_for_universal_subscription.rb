class AddCheckboxForUniversalSubscription < ActiveRecord::Migration
  def self.up
    add_column :users, :subscribe_all, :boolean, :default => 0
    add_index :users, :subscribe_all
  end

  def self.down
    remove_index :users, :subscribe_all
    remove_column :users, :subscribe_all
  end
end