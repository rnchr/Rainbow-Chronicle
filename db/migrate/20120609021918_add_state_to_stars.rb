class AddStateToStars < ActiveRecord::Migration
  def change
    add_column :stars, :state, :string
    add_column :titles, :state, :string
  end
end
