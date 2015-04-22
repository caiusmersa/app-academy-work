def factors(num)
  factors = []
  (1..num).each do |n|
    if num % n == 0
      factors << n
    end
  end
  factors
end

class Array
  def bubble_sort
    sorted = false
    while !sorted
      sorted = true
      self.each_with_index do |el, idx|
        if idx != count - 1 && self[idx + 1] < self[idx]
          self[idx], self[idx + 1] = self[idx + 1], self[idx]
          sorted = false
        end
      end
    end
    self
  end
end

def substrings(string)
  subs = []
  (1..string.length).each do |len|
    (0..string.length-len).each do |start|
      subs << string[start, len]
    end
  end
  subs
end

def subwords(string)
  subs = substrings(string)
  subwords = []
  dictionary = File.readlines("dictionary.txt")
  subs.each do |el|
    subwords << el if dictionary.include?("#{el}\n")
  end
  subwords
end
