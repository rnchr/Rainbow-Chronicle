class AddStarsCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stars_count, :integer
  end
end
