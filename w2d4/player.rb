require_relative 'game_input.rb'

class Player
  attr_accessor :name, :color, :board

  def initialize(name, color)
    @name = name
    @color = color
  end
end

class HumanPlayer < Player
  def initialize(color)
    puts "Hello, you will be playing the " + "⚈"
      .send(PLR_COLOR[color]) + " pieces. What's your name?"
    name = gets.chomp
    puts "Welcome to Ruby Draughts, #{name}!"

    super(name, color)
  end

  def make_move
    input = GameInput.read_char
    cur = board.cursor

    case input
    when "\e[A"                                # UP    arrow
      cur = [[cur[0] - 1, 0].max, cur[1]]
    when "\e[B"                                # DOWN  arrow
      cur = [[cur[0] + 1, SIZE - 1].min, cur[1]]
    when "\e[C"                                # RIGHT arrow
      cur = [cur[0], [cur[1] + 1, SIZE - 1].min]
    when "\e[D"                                # LEFT  arrow
      cur = [cur[0], [cur[1] - 1, 0].max]
    when "\e"                                  # Esc
      exit
    when " ", "\r"                             # Space / Return
      if board.selected_pc.nil?
        board.select!(board.get(*cur))
      elsif board.selected_pc == board.get(*cur)
        board.unselect!
      end
    end

    board.cursor = cur
  end
end

class ComputerPlayer < Player
end