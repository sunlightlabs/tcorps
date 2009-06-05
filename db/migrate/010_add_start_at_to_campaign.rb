class AddStartAtToCampaign < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :start_at, :datetime
  end

  def self.down
    remove_column :campaigns, :start_at
  end
end