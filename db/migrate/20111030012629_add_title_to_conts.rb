class AddTitleToConts < ActiveRecord::Migration
  def change
    add_column :conts, :title, :string
  end
end
