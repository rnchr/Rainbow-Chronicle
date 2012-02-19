class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :title
      t.integer :user_id
      t.string :link
      t.text :body

      t.timestamps
    end
  end
end
