class AddOmniauthToMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :members, :uid, :string
    add_column :members, :image, :string
  end
end
