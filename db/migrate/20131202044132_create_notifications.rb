class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :name
      t.string :key
      t.text :message
      t.integer :user_id

      t.timestamps
    end
  end
end
