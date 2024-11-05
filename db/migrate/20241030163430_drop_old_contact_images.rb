class DropOldContactImages < ActiveRecord::Migration[7.0]
  def change
    remove_column :contacts, :pfp, :binary 
    remove_column :contacts, :picture, :binary 
  end
end
