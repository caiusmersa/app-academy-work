class Code
  protected
  attr_accessor :code

  public
  Colors = ["R", "G", "B", "Y", "O", "P"]

  def self.random
    arr = []
    4.times { arr << Colors.sample }

    arr
  end

  def self.parse(input)
    colors = Code.new(input.chars)
  end

  def initialize(input = Code::random)
    @code = input
  end

  def win?(other_input)
    exact_matches(other_input) == 4
  end

  def exact_matches(other_input)
    count = 0
    (0..3).each { |idx| count += 1 if code[idx] == other_input.code[idx] }

    count
  end

  def near_matches(other_input)
    my_code = code.dup
    other_code = other_input.code.dup

    strip_exact_matches!(my_code, other_code)
    near_matches_in_stripped_codes(my_code, other_code)
  end

  def to_s
    code
  end

  private

  def strip_exact_matches!(one_code, other_code)
    one_code.each_index do |idx|
      if (one_code[idx] == other_code[idx])
        one_code[idx], other_code[idx] = nil, nil
      end
    end
  end

  def near_matches_in_stripped_codes(one_code, other_code)
    count = 0
    one_code.each_with_index do |one_color, one_idx|
      other_code.each_with_index do |other_color, other_idx|
        if one_color && one_color == other_color
          one_code[one_idx], other_code[other_idx] = nil, nil
          count +=1
        end
      end
    end

    count
  end
end

class Game
  private
  attr_reader :hidden_code

  WIN_STATEMENT = "Victory! You broke the code! "
  LOSE_STATEMENT = "Sorry, you ran out of guesses. Game over. :'( . The code was: "

  public

  def initialize
    @guesses = 0
    @win = false
    @hidden_code = Code.new
    play!
  end

  private

  def over?
    @win || @guesses == 8
  end

  def keep_guessing
    guess_code = Code::parse(prompt)
    @win = hidden_code.win?(guess_code)
    @guesses += 1
    puts "Your last guess had #{hidden_code.exact_matches(guess_code)} exact matches
          and #{hidden_code.near_matches(guess_code)} near matches." if !@win
  end

  def play!
    print "Let's play..."
    sleep(1)
    puts "MASTERMIND!!"
    puts "Use the letters to guess: (R)ed, (Y)ellow, (G)reen, (B)lue, (O)range, (P)urple"

    keep_guessing until over?

    puts (@win ? WIN_STATEMENT : LOSE_STATEMENT) + "#{hidden_code.to_s}!"
  end

  def prompt
    print "Take a guess (i.e. RGBY): "
    input = gets.chomp.upcase
    if input.length < 4
      puts "Your input must be 4 letters, you lose a guess!"
      return ""
    end

    input
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
end
