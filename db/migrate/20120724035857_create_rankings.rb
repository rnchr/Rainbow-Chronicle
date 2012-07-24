class CreateRankings < ActiveRecord::Migration
  def change
    create_table :rankings do |t|
      t.integer :place
      t.references :user

      t.timestamps
    end
    add_index :rankings, :user_id
  end
end
