class AddCommentCountToNews < ActiveRecord::Migration
  def change
    add_column :news, :comment_count, :integer, :default => 0
  end
end
