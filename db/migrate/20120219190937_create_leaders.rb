class CreateLeaders < ActiveRecord::Migration
  def change
    create_table :leaders do |t|
      t.string :title
      t.string :phone
      t.text :address
      t.string :website
      t.float :lat
      t.float :lng
      t.integer :picture

      t.timestamps
    end
  end
end
