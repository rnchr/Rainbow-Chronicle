class AddAwardedToStars < ActiveRecord::Migration
  def change
    add_column :stars, :awarded, :integer
  end
end
