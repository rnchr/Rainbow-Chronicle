class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :phone
      t.text :address
      t.string :website
      t.float :lat
      t.float :lng
      t.integer :picture
      t.date :start
      t.date :end
      t.string :timespan

      t.timestamps
    end
  end
end
