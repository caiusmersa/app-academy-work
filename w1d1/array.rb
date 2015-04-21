class Array
  def my_uniq
    result_array = [ ]

    self.each do |i| # More descriptive name, please
      unless result_array.include?(i)
        result_array << i
      end
    end
    result_array
  end

  def two_sum
    result = []
    for i in 0..(self.length - 2)
      for j in (i + 1)..self.length - 1
        result << [i, j] if self[i] + self[j] == 0
      end
    end

    result
  end

end

# array.map.with_index { |el, idx| }

#this method assumes the given matrix is square
def my_transpose(matrix)
  result = Array.new(matrix.first.length) { Array.new(matrix.length) }
  for row in 0...matrix.length
    for col in 0...matrix.first.length
      result[col][row] = matrix[row][col]
    end
  end

  result
end

def print_matrix(matrix)
  matrix.each do |row|
    puts "#{row}\n"
  end
end

def stock_picker(price_array)
  max_profit = 0
  profit_days = [ ]

  for buy_day in 0..price_array.length - 2
    for sell_day in buy_day + 1..price_array.length - 1
      profit = price_array[sell_day] - price_array[buy_day]
      if profit > max_profit
        max_profit = profit
        profit_days = [buy_day,sell_day]
      end
    end
  end

  profit_days
end
