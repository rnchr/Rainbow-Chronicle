class CreateAuxiliaryRatings < ActiveRecord::Migration
  def change
    create_table :auxiliary_ratings do |t|
      t.integer :user_id
      t.integer :linked_id
      t.integer :rating_id
      t.integer :value
      t.string :for

      t.timestamps
    end
  end
end
