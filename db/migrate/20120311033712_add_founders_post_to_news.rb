class AddFoundersPostToNews < ActiveRecord::Migration
  def change
    add_column :news, :founders_post, :boolean, :default => false
  end
end
