class AddTokenExpDateToMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :members, :token_exp_date, :integer
  end
end
