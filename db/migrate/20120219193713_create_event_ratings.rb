class CreateEventRatings < ActiveRecord::Migration
  def change
    create_table :event_ratings do |t|
      t.integer :overall
      t.text :comment
      t.integer :user_id

      t.timestamps
    end
  end
end
