class AddSetToRating < ActiveRecord::Migration
  def change
    add_column :ratings, :set, :integer
    add_column :ratings, :order, :integer
  end
end
