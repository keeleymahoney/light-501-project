class CreateRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :requests do |t|
      t.boolean :status
      t.references :member, null: false, foreign_key: true
      t.integer :type, default: 0

      t.timestamps
    end
  end
end
