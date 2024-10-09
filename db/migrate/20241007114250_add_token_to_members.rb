class AddTokenToMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :members, :google_token, :string
    add_column :members, :token_exp_date, :datetime
  end
end
