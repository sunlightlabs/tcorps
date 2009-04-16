class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.integer :user_id, :campaign_id, :points
      t.datetime :completed_at
      t.string :key
      t.timestamps
    end
    add_index :tasks, [:user_id, :campaign_id]
    add_index :tasks, :campaign_id
    add_index :tasks, :key
  end

  def self.down
    drop_table :tasks
  end
end
