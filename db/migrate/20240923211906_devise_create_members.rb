# frozen_string_literal: true

class DeviseCreateMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :members do |t|
      t.string :email, null: false
      t.string :full_name
      t.string :uid
      t.string :avatar_url

      t.timestamps null: false
    end

    add_index :members, :email, unique: true
  end
end
