class FixRatingAssociations < ActiveRecord::Migration
  def up
    add_column :event_ratings, :event_id, :integer
    add_column :place_ratings, :place_id, :integer
    add_column :leader_ratings, :leader_id, :integer
    
    add_column :events, :user_id, :integer
    add_column :places, :user_id, :integer
    add_column :leaders, :user_id, :integer

  end

  def down
    remove_column :event_ratings, :event_id
    remove_column :place_ratings, :place_id
    remove_column :leader_ratings, :leader_id
    
    remove_column :events, :user_id
    remove_column :places, :user_id
    remove_column :leaders, :user_id
  end
end
