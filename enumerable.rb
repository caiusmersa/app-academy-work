def array_times_two(int_array)
  int_array.map {|num| num * 2}
end

class Array
  def my_each(&prc)
    idx = 0
    while idx < self.count
      prc.call(self[idx])
      idx += 1
    end
    self
  end

  def median_int
    sorted = self.sort
    arr_len = self.count
    if arr_len % 2 == 0
      (sorted[arr_len/2] + sorted[arr_len/2 - 1]) / 2.0
    else
      sorted[arr_len/2]
    end
  end

end


def concatenate(string_array)
  string_array.inject(:+)
end
