class AddRemindersToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :reminder_at_event_start, :boolean, :default => false 
    add_column :events, :reminder_15_mins_before, :boolean, :default => false 
    add_column :events, :reminder_30_mins_before, :boolean, :default => false 
    add_column :events, :reminder_1_hr_before, :boolean, :default => false 
    add_column :events, :reminder_1_day_before, :boolean, :default => false 
  end

  def self.down
    remove_column :events, :reminder_at_event_start
    remove_column :events, :reminder_15_mins_before
    remove_column :events, :reminder_30_mins_before
    remove_column :events, :reminder_1_hr_before
    remove_column :events, :reminder_1_day_before
  end
end
