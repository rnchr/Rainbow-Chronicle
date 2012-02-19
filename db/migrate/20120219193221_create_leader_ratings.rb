class CreateLeaderRatings < ActiveRecord::Migration
  def change
    create_table :leader_ratings do |t|
      t.integer :user_id
      t.integer :voting_record
      t.integer :public_views
      t.integer :inclusion
      t.integer :personal_experience
      t.integer :aggregate
      t.text :comment

      t.timestamps
    end
  end
end
