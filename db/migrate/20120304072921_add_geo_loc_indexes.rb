class AddGeoLocIndexes < ActiveRecord::Migration
  def up
    add_index :places, :lat
    add_index :places, :lng
    add_index :events, :lat
    add_index :events, :lng
    add_index :leaders, :lat
    add_index :leaders, :lng
  end

  def down
    remove_index :places, :lat
    remove_index :places, :lng
    remove_index :events, :lat
    remove_index :events, :lng
    remove_index :leaders, :lat
    remove_index :leaders, :lng
  end
end
