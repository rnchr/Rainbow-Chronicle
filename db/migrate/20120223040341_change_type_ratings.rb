class ChangeTypeRatings < ActiveRecord::Migration
  def change
    add_column :leader_ratings, :overall, :float
    add_column :leader_ratings, :auxiliary_rating_id, :integer
    remove_column :leader_ratings, :rating_id
    remove_column :leader_ratings, :rating
    
    add_column :place_ratings, :overall, :float
    add_column :place_ratings, :auxiliary_rating_id, :integer
    remove_column :place_ratings, :rating_id
    remove_column :place_ratings, :rating
    
    add_column :event_ratings, :overall, :float
    add_column :event_ratings, :auxiliary_rating_id, :integer
    remove_column :event_ratings, :rating_id
    remove_column :event_ratings, :rating
  end
end
