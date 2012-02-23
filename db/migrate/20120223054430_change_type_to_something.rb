class ChangeTypeToSomething < ActiveRecord::Migration
  def change
    rename_column :places, :type, :rating_set
  end

end
