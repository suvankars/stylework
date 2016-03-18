class Contact < ActiveRecord::Base
  belongs_to :supplier, inverse_of: :contact
end
