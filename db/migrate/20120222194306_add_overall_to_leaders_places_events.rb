class AddOverallToLeadersPlacesEvents < ActiveRecord::Migration
  def change
    add_column :leaders, :cached_rating, :float
    add_column :places, :cached_rating, :float
    add_column :events, :cached_rating, :float
  end
end
