class Finance < ActiveRecord::Base
  belongs_to :supplier, inverse_of: :finance
end
