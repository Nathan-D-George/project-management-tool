class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.text  :description
      t.float :budget
      t.float :expenses, default: 0
      t.date :start_date
      t.date :baseline_start_date
      t.date :end_date
      t.date :baseline_end_date
      t.integer :percent_complete, default: 0
      t.integer :leader

    end
  end
end
