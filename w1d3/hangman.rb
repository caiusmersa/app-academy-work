require 'byebug'

DICTIONARY = File.readlines('dictionary.txt').map(&:chomp)

class HumanPlayer
  def initialize
    @guesses = []
  end

  def pick_secret_word
    print "Please input your word length: "
    return Integer(gets)
  end

  def guess(board)
    print "Please input a letter: "
    @letter = gets.chomp
    @guesses << @letter
    @letter
  end

  def check_guess(letter)
    puts "The computer guessed '#{letter}'. Which letters match this?"
    gets.chomp.split(",").map {|num| num.to_i - 1}
  end

  def handle_guess_response
  end

  def receive_secret_length(length)
    @length = length
  end

end

class AIPlayer

  def initialize
    @dict = DICTIONARY.dup
    @guesses = ('a'..'z').to_a
  end

  private

  attr_reader :secret_word

  public

  def pick_secret_word
    @secret_word = ""
    @secret_word = DICTIONARY.sample until secret_word.length > 4
    @secret_word.length
  end

  def guess(board)
    @guesses.shuffle.pop
  end

  def check_guess(letter)
    index = []
    secret_word.chars.each_with_index do |chars, i|
      index << i if chars == letter
    end

    index
  end

  def receive_secret_length(length)
    @length = length
    @dict.select {|word| word.length == length}
  end
end

class Hangman
  attr_reader :guesser, :picker

  def initialize(guesser, picker)
    @guesser = guesser
    @picker = picker
    @board = ""
  end


  def play
    tries = 0
    word_length = picker.pick_secret_word
    @board = '_' * word_length
    guesser.receive_secret_length(word_length)
    until over?
      prompt
      letter = guesser.guess(@board)
      tries += 1
      index = picker.check_guess(letter)
      guess_right(letter, index)
    end
    puts "#{@board.capitalize} was the word! Congrats, you win! It took you #{trues} tries!"
  end

  def prompt
    puts @board
    puts "Make a guess"
  end

  def over?
    !@board.chars.include?('_')
  end

  def guess_right(letter, array)
    array.each do |i|
      @board[i] = letter
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  # game = Hangman.new(HumanPlayer.new, AIPlayer.new)
  game = Hangman.new(AIPlayer.new, HumanPlayer.new)
  game.play
end
