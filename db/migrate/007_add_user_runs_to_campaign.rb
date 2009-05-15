class AddUserRunsToCampaign < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :user_runs, :integer
  end

  def self.down
    remove_column :campaigns, :user_runs
  end
end
