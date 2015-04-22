class Guessing
  attr_reader :num

  def initialize
    @num = (1..100).to_a.shuffle.first
  end

  def play
    check_guess( get_guess("Guess a number: ") )
  end

  def get_guess(message)
    print message
    guess = Integer(gets)
    (1..100).include?(guess) ? guess : get_guess("Guess a number between 1 & 100: ")
  end

  def check_guess(guess)
    if guess > num
      check_guess( get_guess("Too high! Guess again: ") )
    elsif guess < num
      check_guess( get_guess("Too low! Guess again: ") )
    elsif guess == num
      puts "You WIN!! You're a WINNER!!"
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  Guessing.new.play
end

def file_shuffler
  print "Gimme a file you want to shuffle: "
  filename = gets.chomp
  contents = File.readlines(filename)
  contents.each do |line|
    line.chomp!
  end
  contents.shuffle!
  file_title = filename.delete(".txt")
  shuffled_file = File.open("#{file_title}-shuffled.txt", "w")
  contents.each { |line| shuffled_file.puts line }
  shuffled_file.close

  File.open("#{file_title}-shuffled.txt", "w") do |shuffled_file|
    contents.each { |line| shuffled_file.puts line }
  end
end
