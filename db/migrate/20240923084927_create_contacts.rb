# frozen_string_literal: true

class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :organization
      t.string :title
      t.string :link
      t.text :bio
      # t.binary :picture, limit: 4.megabytes

      t.timestamps
    end
  end
end
