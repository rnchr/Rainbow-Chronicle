class CreateTitles < ActiveRecord::Migration
  def change
    create_table :titles do |t|
      t.references :user
      t.string :city
      t.string :name

      t.timestamps
    end
    add_index :titles, :user_id
  end
end
