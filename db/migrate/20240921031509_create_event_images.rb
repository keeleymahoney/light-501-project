class CreateEventImages < ActiveRecord::Migration[7.0]
  def change
    create_table :event_images do |t|
      t.references :event, null: false, foreign_key: true
      t.binary :picture, limit: 16.megabytes

      t.timestamps
    end
  end
end
