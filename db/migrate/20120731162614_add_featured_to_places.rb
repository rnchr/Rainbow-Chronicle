class AddFeaturedToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :city_featured, :boolean, :default => false
    add_column :places, :category_featured, :boolean, :default => false
  end
end
