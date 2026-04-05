class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.integer :event_id
      t.string :title
      
      t.timestamps
    end
  end
end
