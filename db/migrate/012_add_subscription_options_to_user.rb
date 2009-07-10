class AddSubscriptionOptionsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :subscribe_campaigns, :boolean, :default => 0
    add_index :users, :subscribe_campaigns
  end

  def self.down
    remove_index :users, :subscribe_campaigns
    remove_column :users, :subscribe_campaigns
  end
end