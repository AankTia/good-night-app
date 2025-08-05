class CreateSleepRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :sleep_records do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :sleep_time, null: false
      t.datetime :wake_up_time
      t.integer :duration_seconds
      t.timestamps
    end

    add_index :sleep_records, [:user_id, :created_at]
    add_index :sleep_records, :sleep_time
    add_index :sleep_records,  :duration_seconds
    add_index :sleep_records, :created_at
  end
end
