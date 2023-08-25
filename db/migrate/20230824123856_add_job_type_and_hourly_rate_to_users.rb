class AddJobTypeAndHourlyRateToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :job, :integer, default: 0
    add_column :users, :hourly_rate, :integer
    add_column :milestones, :budget, :integer
  end
end