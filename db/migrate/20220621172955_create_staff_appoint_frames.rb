class CreateStaffAppointFrames < ActiveRecord::Migration[7.0]
  def change
    create_table :staff_appoint_frames do |t|
      t.datetime :acceptable_frame_start
      t.datetime :acceptable_frame_end
      t.references :staff, null: false, foreign_key: true

      t.timestamps
    end
  end
end
