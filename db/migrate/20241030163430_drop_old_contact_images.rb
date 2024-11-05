class DropOldContactImages < ActiveRecord::Migration[7.0]
  def change
    remove_column :contacts, :pfp, :binary 
  end
end
