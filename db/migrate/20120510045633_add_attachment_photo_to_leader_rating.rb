class AddAttachmentPhotoToLeaderRating < ActiveRecord::Migration
  def self.up
    add_column :leader_ratings, :photo_file_name, :string
    add_column :leader_ratings, :photo_content_type, :string
    add_column :leader_ratings, :photo_file_size, :integer
    add_column :leader_ratings, :photo_updated_at, :datetime
  end

  def self.down
    remove_column :leader_ratings, :photo_file_name
    remove_column :leader_ratings, :photo_content_type
    remove_column :leader_ratings, :photo_file_size
    remove_column :leader_ratings, :photo_updated_at
  end
end
