class AddPandoraThatToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pandora_that, :string
  end
end
