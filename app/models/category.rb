class Category < ActiveRecord::Base
	has_many :subcategories, dependent: :destroy
	validates :name, :description, presence: true
end
