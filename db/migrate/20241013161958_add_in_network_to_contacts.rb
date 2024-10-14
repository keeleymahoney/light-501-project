class AddInNetworkToContacts < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :in_network, :boolean, default: false
  end
end
