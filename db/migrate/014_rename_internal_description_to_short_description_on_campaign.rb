class RenameInternalDescriptionToShortDescriptionOnCampaign < ActiveRecord::Migration
  def self.up
    rename_column :campaigns, :private_description, :short_description
  end

  def self.down
    rename_column :campaigns, :short_description, :private_description
  end
end