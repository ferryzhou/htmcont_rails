class CreateConts < ActiveRecord::Migration
  def change
    create_table :conts do |t|
      t.string :link
      t.text :html
      t.text :content
      t.integer :error_type
      t.text :error_msg

      t.timestamps
    end
  end
end
