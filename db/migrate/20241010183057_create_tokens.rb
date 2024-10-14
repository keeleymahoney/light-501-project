class CreateTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :tokens do |t|
      t.text :access_token
      t.text :token_exp
      t.references :member, null: false, foreign_key: true

      t.timestamps
    end
  end
end
