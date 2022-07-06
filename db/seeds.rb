# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


#############################
# Master Data
#############################
weekdays = [
  {id: 0, weekday: 'Sun', start: '', end: ''},
  {id: 1, weekday: 'Mon', start: '10:00', end: '18:00'},
  {id: 2, weekday: 'Tue', start: '10:00', end: '18:00'},
  {id: 3, weekday: 'Wed', start: '10:00', end: '18:00'},
  {id: 4, weekday: 'Thu', start: '10:00', end: '18:00'},
  {id: 5, weekday: 'Fri', start: '10:00', end: '18:00'},
  {id: 6, weekday: 'Sat', start: '11:00', end: '15:00'},
]

# BusinessTimeMaster
weekdays.each_with_index do |w, i|
  biz_time = BusinessTimeMaster.create(
    weekday_id: w[:id],
    weekday: w[:weekday],
    start_time: w[:start],
    end_time: Time.zone.parse(w[:end]),
  )
  p biz_time
end

#############################
# Sample Data
#############################
# Staff
10.times do |n|
  staff = Staff.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    first_name_kana: Faker::Name.first_name.downcase,
    last_name_kana: Faker::Name.last_name.downcase,
    email: Faker::Internet.email,
    password: Faker::Internet.password(min_length: 6, max_length: 20)
  )
  # p staff
end

# Customer
10.times do |n|
  customer = Customer.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    first_name_kana: Faker::Name.first_name.downcase,
    last_name_kana: Faker::Name.last_name.downcase,
    email: Faker::Internet.email,
    password: Faker::Internet.password(min_length: 6, max_length: 20)
  )
  # p customer
end


# StaffAppointFrame
staffs = Staff.all.limit(3)
# year = 2022
# month = 7
# day = 1
from = Time.zone.local(2022, 7, 1)
to = Time.zone.local(2022, 9).end_of_month
staff_appoint_frames = []
(from.to_date..to.to_date).each do |d|
  year = d.year.to_i
  month = d.month.to_i
  day = d.day
  staffs.each do |st|
    (10..11).each do |h|
      frame1 = StaffAppointFrame.new(
        staff: st,
        acceptable_frame_start: Time.zone.local(year, month, day, h, 0),
        acceptable_frame_end: Time.zone.local(year, month, day, h, 30),
      )
      if frame1.valid?
        staff_appoint_frames << frame1.attributes.except("id", "created_at", "updated_at")
      end
      frame2 = StaffAppointFrame.new(
        staff: st,
        acceptable_frame_start: Time.zone.local(year, month, day, h, 30),
        acceptable_frame_end: Time.zone.local(year, month, day, h + 1, 0),
      )
      if frame2.valid?
        staff_appoint_frames << frame2.attributes.except("id", "created_at", "updated_at")
      end    
    end
    (13..17).each do |h|
      frame1 = StaffAppointFrame.new(
        staff: st,
        acceptable_frame_start: Time.zone.local(year, month, day, h, 0),
        acceptable_frame_end: Time.zone.local(year, month, day, h, 30),
      )
      if frame1.valid?
        staff_appoint_frames << frame1.attributes.except("id", "created_at", "updated_at")
      end 
      frame2 = StaffAppointFrame.new(
        staff: st,
        acceptable_frame_start: Time.zone.local(year, month, day, h, 30),
        acceptable_frame_end: Time.zone.local(year, month, day, h + 1, 0),
      )
      if frame2.valid?
        staff_appoint_frames << frame2.attributes.except("id", "created_at", "updated_at")
      end    
    end
  end
end
StaffAppointFrame.insert_all staff_appoint_frames

# Appoint Sample
# Appoint.create(
#   staff: Staff.find(1),
#   customer: Customer.find(1),
#   start_datetime: Time.zone.local(year, month, day, 10, 0),
#   end_datetime: Time.zone.local(year, month, day, 10, 30),
#   consultation_content: 'test',
# )
# Appoint.create(
#   staff: Staff.find(2),
#   customer: Customer.find(2),
#   start_datetime: Time.zone.local(year, month, day, 11, 0),
#   end_datetime: Time.zone.local(year, month, day, 11, 30),
#   consultation_content: 'test',
# )