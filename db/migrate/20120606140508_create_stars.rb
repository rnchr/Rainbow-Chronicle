class CreateStars < ActiveRecord::Migration
  def change
    create_table :stars do |t|
      t.references :user
      t.string :city

      t.timestamps
    end
    add_index :stars, :user_id
  end
end
