class DeviseCreateMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :members do |t|
      t.integer :contact_id, null: false
      t.string :email, null: false
      t.string :full_name
      t.boolean :admin, default: false
      t.datetime :network_exp
      t.datetime :constitution_exp
      t.timestamps null: false

      t.index :email, unique: true
      t.index :contact_id
    end

    # Adding foreign key constraint to the contacts table
    add_foreign_key :members, :contacts, column: :contact_id
  end
end
