class AddTitlesCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :titles_count, :integer, :default => 0
  end
end
