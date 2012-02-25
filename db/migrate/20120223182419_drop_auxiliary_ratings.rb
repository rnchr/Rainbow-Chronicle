class DropAuxiliaryRatings < ActiveRecord::Migration
  def change
    drop_table :auxiliary_ratings
    
    remove_column :place_ratings, :auxiliary_rating_id
    add_column :place_ratings, :review, :text
    remove_column :leader_ratings, :auxiliary_rating_id
    add_column :leader_ratings, :review, :text
    remove_column :event_ratings, :auxiliary_rating_id
    add_column :event_ratings, :review, :text
  end
end
