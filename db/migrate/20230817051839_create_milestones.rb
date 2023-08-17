class CreateMilestones < ActiveRecord::Migration[7.0]
  def change
    create_table :milestones do |t|
      t.string  :name
      t.text    :description, default: 'Description'
      t.date    :start_date
      t.date    :baseline_start_date
      t.date    :end_date
      t.date    :baseline_end_date
      t.integer :completion, default: 0
      t.references :project, null: false, foreign_key: true

    end
  end
end
