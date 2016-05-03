module Computation
  class Measurement
    attr_accessor :length

    def to_cm
      length.to_cm
    end

    def to_ft_cm
      "#{length.to_feet}" + " " + "(#{length.to_cm})"
    end

    def inch
      length.to_i
    end
  end
end  