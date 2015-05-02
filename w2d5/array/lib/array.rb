class Array
  alias_method :my_uniq, :uniq
  alias_method :my_transpose, :transpose

  def two_sum
    results = []
    (0..length-2).each do |i|
      (i+1...length).each do |j|
        results << [i,j] if self[i] + self[j] == 0
      end
    end
    results
  end



end
