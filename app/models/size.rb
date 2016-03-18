class Size < ActiveRecord::Base

  def description
    "#{name}   (#{volume} #{unit})"
  end
end
