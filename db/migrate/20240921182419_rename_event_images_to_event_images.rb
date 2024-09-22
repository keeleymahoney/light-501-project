class RenameEventImagesToEventImages < ActiveRecord::Migration[7.0]
  def change
    rename_table :eventimages, :event_images
  end
end
