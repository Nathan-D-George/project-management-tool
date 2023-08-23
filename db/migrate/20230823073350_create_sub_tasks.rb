class CreateSubTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :sub_tasks do |t|
      t.string :name
      t.text :description
      t.boolean :complete, default: false
      t.references :task, null: false, foreign_key: true

    end
  end
end
