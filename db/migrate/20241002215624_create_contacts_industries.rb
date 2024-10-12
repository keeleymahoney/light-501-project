class CreateContactsIndustries < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts_industries, id: false do |t|
      t.references :contact, null: false, foreign_key: true
      t.references :industry, null: false, foreign_key: true

      t.timestamps
    end
  end
end
