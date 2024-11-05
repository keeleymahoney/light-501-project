class DropEventImages < ActiveRecord::Migration[7.0]
  def change
    drop_table :event_images
  end
end
