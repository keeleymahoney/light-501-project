class CreateRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :requests do |t|
      t.integer :status, default: 0
      t.references :member, null: false, foreign_key: true
      t.integer :request_type, default: 0
      t.text :description

      t.timestamps
    end
  end
end
