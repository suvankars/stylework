module CoreExtensions
  module Integer
    def to_cm
      inches = self.to_i
      expression = "#{(inches * 2.54).round} cm"
    end
    def to_feet
      inches = self.to_i
      expression = "#{(inches / 12).truncate}\'#{(inches % 12).round}\""
    end
  end
 
end