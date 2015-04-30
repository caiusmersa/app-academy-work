
require_relative 'input.rb'
require_relative 'player.rb'
require_relative 'board.rb'

require 'colorize'

class Game

  def initialize
    game_board = Board.new
    h_players = Game.main_menu

    return unless h_players[2]

    player1 = h_players[0] ? HumanPlayer.new(:W, game_board) :
                             ComputerPlayer.new("Magnus 128K", :W, game_board)
    player2 = h_players[1] ? HumanPlayer.new(:B, game_board) :
                             ComputerPlayer.new("Deep Red Ruby", :B, game_board)
    game_board.white_name = player1.name
    game_board.black_name = player2.name

    until game_board.game_over?
      game_board.display_board(true)
      feedback = game_board.player_turn == :W ? player1.get_move : player2.get_move

    end
  end

  def self.main_menu

    p1human = true
    p2human = true

    selected = [2, 0]
    menu_done = false

    menu = [["  Player  ".cyan, " Computer "],
            ["  Player  ".cyan, " Computer "],
              ["    OK    ", "   Exit   "]]

    until menu_done
      system("clear")

      puts "\n\n\n".on_black
      # puts "  Welcome to ASCII Chess - Fireworks Edition  ".cyan
      print   "   Welcome to ASCII Chess - Fireworks Edition".cyan
      # puts "\n".on_black
      puts File.read('logo.txt')
      puts "".on_black
      menu.each_with_index do |row, r|
        row.each_with_index { |item, i| menu[r][i] = item.on_black }
      end

      menu[selected[0]][selected[1]] = menu[selected[0]][selected[1]].on_yellow

      print "            #{"  White: ".red.on_white}  #{menu[0][0]}   #{menu[0][1]}\n"
      print "            #{"  Black: ".black.on_white}  #{menu[1][0]}   #{menu[1][1]}\n\n"
      print "                       #{menu[2][0]}   #{menu[2][1]}\n\n"

      input = ChessInput.read_char

      case input
      when "\e[A"
        selected = [[selected[0] - 1, 0].max, selected[1]]
      when "\e[D"
        selected = [selected[0], [selected[1] - 1, 0].max]
      when "\e[B"
        selected = [[selected[0] + 1, 2].min, selected[1]]
      when "\e[C"
        selected = [selected[0], [selected[1] + 1, 1].min]
      when "\e"
        exit
      when " "
        if selected == [0, 1]
          menu[0][1] = menu[0][1].cyan
          menu[0][0] = menu[0][0].white
          p1human = false
        elsif selected == [1, 1]
          menu[1][1] = menu[1][1].cyan
          menu[1][0] = menu[1][0].white
          p2human = false
        elsif selected == [0, 0]
          menu[0][0] = menu[0][0].cyan
          menu[0][1] = menu[0][1].white
          p1human = true
        elsif selected == [1, 0]
          menu[1][0] = menu[1][0].cyan
          menu[1][1] = menu[1][1].white
          p2human = true
        elsif selected == [2, 0]
          menu_done = true
          continue = true
        elsif selected == [2, 1]
          menu_done = true
          continue = false
        end
      end
    end
    [p1human, p2human, continue]
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.main_menu
end
