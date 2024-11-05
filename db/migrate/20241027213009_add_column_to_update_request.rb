class AddColumnToUpdateRequest < ActiveRecord::Migration[7.0]
  def change
    add_reference :requests, :contacts
  end
end
