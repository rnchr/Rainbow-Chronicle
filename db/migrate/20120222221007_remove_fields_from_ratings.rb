class RemoveFieldsFromRatings < ActiveRecord::Migration
  def change
    remove_column :leader_ratings, :voting_record
    remove_column :leader_ratings, :public_views
    remove_column :leader_ratings, :inclusion
    remove_column :leader_ratings, :personal_experience
    remove_column :leader_ratings, :overall
    add_column :leader_ratings, :rating_id, :integer
    
    remove_column :place_ratings, :overall
    remove_column :place_ratings, :same_sex
    remove_column :place_ratings, :lgbt_group
    remove_column :place_ratings, :lgbt_comfort
    remove_column :place_ratings, :customer_attitude
    remove_column :place_ratings, :lgbt_popularity
    add_column :place_ratings, :rating_id, :integer
    
    remove_column :event_ratings, :overall
    add_column :event_ratings, :rating_id, :integer
    
  end
end
