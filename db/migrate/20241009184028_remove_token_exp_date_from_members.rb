class RemoveTokenExpDateFromMembers < ActiveRecord::Migration[7.0]
  def change
    remove_column :members, :token_exp_date
  end
end
