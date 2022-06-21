class CreateBusinessTimeMasters < ActiveRecord::Migration[7.0]
  def change
    create_table :business_time_masters do |t|
      t.string :week
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
  end
end
