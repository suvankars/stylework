class Schedule < ActiveRecord::Base
  belongs_to :list

  scope :between, -> (start_time, end_time) { where('
                (start_time >= :start_time and end_time <= :end_time) or
                (start_time >= :start_time and end_time > :end_time and start_time <= :end_time) or
                (start_time <= :start_time and end_time >= :start_time and end_time <= :end_time) or
                (start_time <= :start_time and end_time > :end_time)',
                start_time: format_date(start_time), end_time: format_date(end_time) ) }

  def self.format_date(date_time)
    date_time.to_time.to_formatted_s(:db)
  end

end
