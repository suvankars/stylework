json.array!(@frontend_schedules) do |frontend_schedule|
  json.extract! frontend_schedule, :id, :start_date, :end_date, :start_time, :end_time, :morning_ride, :evening_ride, :all_day
  json.url frontend_schedule_url(frontend_schedule, format: :json)
end
