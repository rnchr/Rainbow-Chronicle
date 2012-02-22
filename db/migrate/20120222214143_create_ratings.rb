class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.string :text
      t.string :for

      t.timestamps
    end
  end
end
