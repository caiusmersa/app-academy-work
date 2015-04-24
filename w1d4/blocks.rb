class Array
  def my_each(&prc)
   for idx in 0..length - 1
     prc.call(self[idx])
   end

   self
  end

  def my_map(&prc)
    new_array = []
    my_each { |el| new_array << prc.call(el) }

    new_array
  end

  def my_select(&prc)
    new_array = []
    my_each do |el|
      new_array << el if prc.call(el)
    end

    new_array
  end

  def my_inject(&prc)
    accumulator = nil
    my_each do |el|
      if accumulator
        accumulator = prc.call(accumulator, el)
      else
        accumulator = el
      end
    end

    accumulator
  end

  def my_sort!(&prc)
    return self if length < 2

    left, right = [], []
    pivot = self[length / 2]

    each_with_index do |el, idx|
      next if idx == length / 2
      prc.call(pivot, el) == -1 ? right << el : left << el
    end

    self[0...left.length] = left.my_sort!(&prc)
    self[left.length] = pivot
    self[left.length + 1..-1] = right.my_sort!(&prc)

    self
  end

  def my_sort(&prc)
    dup.my_sort!(&prc)
  end
end

def eval_block(*args, &prc)
  block_given? ? prc.call(*args) : puts("No block given")
end


if __FILE__ == $PROGRAM_NAME
  array = [0,1,3,4]
  puts array.inject {|sum, n| sum + n**2}

  unsorted_array = [4,1,6,3,1,7,2]
  sorted_array = unsorted_array.my_sort { |x, y| x <=> y }
  p unsorted_array
  p sorted_array

  p eval_block(1, 2, 3) { |x, y, z| x + y + z }
  arr = [4, 5, 6]
  p eval_block(arr) { |x, y, z| x + y + z }

end
