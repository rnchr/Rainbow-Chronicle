class ChangeCachedRatingDefault < ActiveRecord::Migration
  def change
    change_column :places, :cached_rating, :float, :default => 0
    change_column :leaders, :cached_rating, :float, :default => 0
    change_column :events, :cached_rating, :float, :default => 0
  end
end
