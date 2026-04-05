class AddRecurrenceToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :periodicity, :integer
    add_column :events, :frequency, :integer, :default => 1
  end

  def self.down
    remove_column :events, :periodicity
    remove_column :events, :frequency
  end
end
