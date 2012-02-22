class AddPhotoAndLockToNews < ActiveRecord::Migration
  def change
    add_column :news, :photo, :string
    add_column :news, :lock, :integer, :default => 0
  end
end
