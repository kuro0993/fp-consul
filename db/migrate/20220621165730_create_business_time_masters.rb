class CreateBusinessTimeMasters < ActiveRecord::Migration[7.0]
  def change
    create_table :business_time_masters do |t|
      t.integer :weekday_id, limit: 1
      t.string :weekday
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
    add_index :business_time_masters, [:weekday_id], unique: true
  end
end