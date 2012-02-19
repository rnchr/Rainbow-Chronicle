class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
       t.string :title
       t.string :description
       t.string :phone
       t.text :address
       t.string :website
       t.float :lat
       t.float :lng
       t.integer :picture
       t.text :hours_of_operation
       t.timestamps
    end
  end
end
