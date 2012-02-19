class CreatePlaceRatings < ActiveRecord::Migration
  def change
    create_table :place_ratings do |t|
      t.integer :user_id
      t.integer :overall
      t.integer :same_sex
      t.integer :lgbt_group
      t.integer :lgbt_comfort
      t.integer :customer_attitude
      t.integer :lgbt_popularity
      t.text :comment

      t.timestamps
    end
  end
end
