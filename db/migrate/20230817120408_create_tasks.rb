class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.date :baseline_start_date
      t.date :start_date
      t.date :baseline_end_date
      t.date :end_date
      t.boolean :complete, default: false
      t.integer :assigned_to
      t.belongs_to :milestone, null: false, foreign_key: true

    end
  end
end
