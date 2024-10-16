class AddPfpToContacts < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :pfp, :binary, limit: 16.megabytes
  end
end
