class CreateLogs < ActiveRecord::Migration
  def change
    create_table :message_logs, force: true do |t|
      t.integer :user_id
      t.string :text
      t.boolean :application_originated
      t.timestamps
    end

    add_index :message_logs, :user_id
  end
end
