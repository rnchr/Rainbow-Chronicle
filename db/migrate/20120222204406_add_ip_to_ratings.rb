class AddIpToRatings < ActiveRecord::Migration
  def change
    add_column :event_ratings, :ip_address, :string
    add_column :place_ratings, :ip_address, :string
    add_column :leader_ratings, :ip_address, :string
  end
end
