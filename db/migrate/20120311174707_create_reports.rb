class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :post_type
      t.integer :user_id
      t.integer :item_id
      t.string :report_type
      t.text :report_content
      t.string :ip_address

      t.timestamps
    end
  end
end
