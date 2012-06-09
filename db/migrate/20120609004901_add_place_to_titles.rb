class AddPlaceToTitles < ActiveRecord::Migration
  def change
    add_column :titles, :place, :integer

  end
end
