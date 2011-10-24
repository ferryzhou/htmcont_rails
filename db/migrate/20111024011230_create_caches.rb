class CreateCaches < ActiveRecord::Migration
  def change
    create_table :caches do |t|
      t.string :link
      t.text :html
      t.text :content
      t.integer :error_type
      t.text :error_msg
      t.text :error_msg2

      t.timestamps
    end
  end
end
