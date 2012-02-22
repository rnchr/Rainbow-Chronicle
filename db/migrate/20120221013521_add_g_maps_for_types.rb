class AddGMapsForTypes < ActiveRecord::Migration
  def change
    add_column :leaders, :gmaps, :boolean
    add_column :events, :gmaps, :boolean
    add_column :places, :gmaps, :boolean
  end
end
