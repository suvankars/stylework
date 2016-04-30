class List < ActiveRecord::Base
   
  filterrific(
  default_filter_params: { sorted_by: 'created_at_desc' },
  available_filters: [
    :sorted_by,
    :search_query,
    :with_rider_height,
    :with_frame_size,
    :with_created_at_gte
  ]
  )

  belongs_to :category
  belongs_to :subcategory

  geocoded_by :address   
  # auto-fetch coordinates
  after_validation :geocode
   
  has_many :schedules

  scope :with_created_at_gte, lambda { |ref_date|
    where('lists.created_at >= ?', ref_date)
  }
end


