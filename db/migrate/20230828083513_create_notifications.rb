class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.integer :kind, default: 0
      t.string  :message
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
