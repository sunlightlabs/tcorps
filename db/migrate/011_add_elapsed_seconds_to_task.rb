class AddElapsedSecondsToTask < ActiveRecord::Migration
  def self.up
    add_column :tasks, :elapsed_seconds, :integer
  end

  def self.down
    remove_column :tasks, :elapsed_seconds
  end
end