class AddRatingToRatings < ActiveRecord::Migration
  def change
    add_column :event_ratings, :rating, :integer
    add_column :leader_ratings, :rating, :integer
    add_column :place_ratings, :rating, :integer
  end
end
