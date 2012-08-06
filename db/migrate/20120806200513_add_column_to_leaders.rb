class AddColumnToLeaders < ActiveRecord::Migration
  def change
    add_column :leaders, :city_featured, :boolean, :default => false
    add_column :leaders, :category_featured, :boolean, :default => false
  end
end


