class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.integer :parent_id
      t.string :name
      t.string :type
      
      t.timestamps
    end
    
    create_table :category_hierarchies, :id => false do |t|
          t.integer  :ancestor_id, :null => false   # ID of the parent/grandparent/great-grandparent/... tag
          t.integer  :descendant_id, :null => false # ID of the target tag
          t.integer  :generations, :null => false   # Number of generations between the ancestor and the descendant. Parent/child = 1, for example.
        end

        # For "all progeny of..." selects:
        add_index :category_hierarchies, [:ancestor_id, :descendant_id], :unique => true

        # For "all ancestors of..." selects
        add_index :category_hierarchies, [:descendant_id]
    
    create_table :event_categories do |t|
      t.integer :event_id
      t.integer :event_type_id
    end
    create_table :place_categories do |t|
      t.integer :place_id
      t.integer :place_type_id
    end
    create_table :leader_categories do |t|
      t.integer :leader_id
      t.integer :leader_type_id
    end
  end
end
