class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.primary_key :id
      t.string :name
      t.datetime :date
      t.text :description
      t.text :location
      t.integer :attendees

      t.timestamps
    end
  end
end
