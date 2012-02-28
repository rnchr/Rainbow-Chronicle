class AddUserAgentToComments < ActiveRecord::Migration
  def change
    add_column :comments, :user_agent, :string
  end
end
