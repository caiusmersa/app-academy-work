def range(start, finish)
  return [] if start > finish
  return [start] if start == finish
  [start] + range(start + 1, finish)
end

class Array
  def recursive_sum
    return 0 if count == 0
    first + self[1..-1].recursive_sum
  end

  def iterative_sum
    inject(:+)
  end

  def deep_dup
    new_array = []
    each { |el| new_array << (el.is_a?(Array) ? el.deep_dup : el) }

    new_array
  end

  def merge_sort
    return self if length <= 1

    left_half = self[0...length / 2]
    right_half = self[length / 2..-1]
    p "Left half is #{left_half}."
    p "Right half is #{right_half}."
    Array.merge(left_half.merge_sort, right_half.merge_sort)
  end

  # protected
  def self.merge(array1, array2)
    p "Trying to merge: #{array1}, #{array2}"
    new_array = []
    idx1, idx2 = 0, 0
    while (idx1 < array1.length) || (idx2 < array2.length)
      num1 = array1[idx1]
      num2 = array2[idx2]

      if idx1 >= array1.length || (num1 && num2 && num1 >= num2)
        new_array << num2
        idx2 += 1
      elsif idx2 >= array2.length || (num1 && num2 && num1 < num2)
        new_array << num1
        idx1 += 1
      end
    end

    p "Merged into #{new_array}"
    new_array

    # p "merging #{array1.inspect} and #{array2} into #{new_array}"
    # new_array
  end
end

def exp1(b, exp)
  exp.zero? ? 1 : b * exp1(b, exp - 1)
end

def exp2(b, exp)
  return 1 if exp == 0
  return b if exp == 1
  temp = exp.even? ? exp2(b, exp / 2) : exp2(b, (exp - 1) / 2)
  exp.even? ? temp * temp : b * temp * temp
end

def fibonacci_rec(n)
  return [1] if n == 1
  return [1, 1] if n == 2
  array = fibonacci_rec(n - 1)
  array + [array[-1] + array[-2]]
end

def fibonacci_iterative(n)
  return [1] if n == 1
  fib = [1, 1]
  (n - 2).times { fib << fib[-1] + fib[-2] }
  fib
end

def bsearch(array, target)
  return nil if array.empty?

  midpoint = array.length / 2

  if target > array[midpoint]
    r_search = bsearch(array[midpoint + 1..-1], target)
    r_search.nil? ? nil : r_search + midpoint + 1
  elsif target < array[midpoint]
    bsearch(array[0...midpoint], target)
  else
    midpoint
  end
end

def make_change(sum, units)
  return [] if units.empty?

  coin = units.shift
  num_coins = sum / coin
  remainder = sum % coin
  [coin] * num_coins + make_change(remainder, units)
end

#UGHHHHHH
def best_change(sum, units)
  return [] if units.empty?

  candidates = []
  (0..units.length - 1).each do |n|
    coin = units[n]
    max_coins = sum / coin
    for num_coins in 1..max_coins
      subroutine = best_change(sum - coin * num_coins, units[n + 1..-1])
      puts "WHAT THE F" if subroutine.nil?
      candidates << [coin] * num_coins + subroutine
    end
  end

  candidates.sort_by { |change| change.length }.first || []
end

def best_change2(sum, units)
  return [] if units.empty? || sum <= 0

  candidates = []
  units.each do |coin|
    # coin = units[n]
    # num_coins = sum / coin
    next if coin > sum
    remainder = sum - coin
    candidates << ([coin] + best_change(remainder, units))
  end

  candidates.min_by { |change| change.length }
end

if __FILE__ == $PROGRAM_NAME
  p [1,5,7,3,2,8,67,1,83,1,11,678,13,71,89].merge_sort
  # p Array.merge([2,3,51,89,7898], [20,71,444,4433])
  # p best_change(114, [30, 10, 7, 1])

  # p range(1,0)
  # p range(2,2)
  # p range(2,5)
  #
  # puts [2,4,5,6,1000].iterative_sum
  # puts [2].iterative_sum
  # puts [].iterative_sum
  #
  # puts exp1(2,3)
  # puts exp2(3,5)
  # puts exp2(1,0)
  # puts exp2(5,1)
  # puts exp2(-10, 5)
  #
  # robot_parts = [
  #   ["nuts", "bolts", "washers"],
  #   ["capacitors", "resistors", "inductors"]
  # ]
  #
  # robot_parts_copy = robot_parts.deep_dup
  #
  # robot_parts_copy[1] << "LEDs"
  # puts "___"
  # p robot_parts
  # p robot_parts_copy
  #
  # p fibonacci_rec(1)
  # p fibonacci_rec(2)
  # p fibonacci_rec(10)
  #
  # p fibonacci_iterative(1)
  # p fibonacci_iterative(2)
  # p fibonacci_iterative(10)
  #
  # puts "\nbsearch tests"
  # p bsearch([1, 2, 3], 1) # => 0
  # p bsearch([2, 3, 4, 5], 3) # => 1
  # p bsearch([2, 4, 6, 8, 10], 6) # => 2
  # p bsearch([1, 3, 4, 5, 9], 5) # => 3
  # p bsearch([1, 2, 3, 4, 5, 6], 6) # => 5
  # p bsearch([1, 2, 3, 4, 5, 6], 0) # => nil
  # p bsearch([1, 2, 3, 4, 5, 7], 6) # => nil
end
