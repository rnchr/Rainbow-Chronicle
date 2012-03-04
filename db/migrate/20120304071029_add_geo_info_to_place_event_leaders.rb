class AddGeoInfoToPlaceEventLeaders < ActiveRecord::Migration
  def change
    add_column :places, :state, :string
    add_column :places, :city, :string
    add_column :places, :zipcode, :string

    add_column :leaders, :state, :string
    add_column :leaders, :city, :string
    add_column :leaders, :zipcode, :string
    
    add_column :events, :state, :string
    add_column :events, :city, :string
    add_column :events, :zipcode, :string

  end
end
