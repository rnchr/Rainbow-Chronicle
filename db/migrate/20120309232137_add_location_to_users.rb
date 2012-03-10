class AddLocationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :location, :string
    add_column :users, :lat, :float
    add_column :users, :lng, :float
  end
end
