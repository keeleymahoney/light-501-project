# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :date
      t.text :description
      t.text :location
      t.text :rsvp_link
      t.text :feedback_link
      t.timestamps
    end
  end
end
