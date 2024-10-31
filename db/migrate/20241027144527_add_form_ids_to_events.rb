class AddFormIdsToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :rsvp_id, :text
    add_column :events, :feedback_id, :text
  end
end
