class RPNCalculator
  def initialize
    @stack = []
  end

  def value
    @stack.last
  end

  def evaluate(rpn_string)
    entries = rpn_string.split

    entries.each do |entry|
      case entry
      when "+";plus
      when "-"; minus
      when "*"; times
      when "/"; divide
      else
        push(entry.to_f)
      end
    end

    return value
  end

  def push(num)
    @stack.push(num)
  end

  def check_stack
    if @stack.size < 2
      raise "calculator is empty"
    end
  end

  def plus
    check_stack
    @stack.push(@stack.pop + @stack.pop)
  end

  def minus
    check_stack
    to_minus = @stack.pop
    @stack.push(@stack.pop - to_minus)
  end

  def times
    check_stack
    @stack.push(@stack.pop * @stack.pop)
  end

  def divide
    check_stack
    denominator = @stack.pop.to_f
    @stack.push(@stack.pop / denominator)
  end
end

if __FILE__ == $PROGRAM_NAME
  new_calc = RPNCalculator.new
  if ARGV[0].nil?
    puts "What would you like to calculate?"
    polish_string = gets.chomp
  else
    polish_string = File.read(ARGV[0])
  end
  puts new_calc.evaluate(polish_string)
end
