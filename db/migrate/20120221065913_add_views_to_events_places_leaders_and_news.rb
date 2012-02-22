class AddViewsToEventsPlacesLeadersAndNews < ActiveRecord::Migration
  def change
    add_column :places, :views, :integer
    add_column :leaders, :views, :integer
    add_column :events, :views, :integer
    add_column :news, :views, :integer
  end
end
