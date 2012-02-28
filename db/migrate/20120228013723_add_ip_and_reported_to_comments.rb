class AddIpAndReportedToComments < ActiveRecord::Migration
  def change
    add_column :comments, :ip_address, :string
    add_column :comments, :reported, :integer
  end
end
