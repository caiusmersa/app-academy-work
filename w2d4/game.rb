require_relative 'board.rb'
# require_relative ''

require "io/console"

class DraughtsGame
  def self.new_game_from_menu
    p1, p2 = 0
    cur = [2, 0]

    while true
      menu = [["  Player  ", " Computer "],
              ["  Player  ", " Computer "],
              ["    OK    ", "   Exit   "]]

      system("clear")
      print "\n\n\n\n"

      # color appropriate menu items
      menu[0][p1] = menu[0][p1].send(MENU_CLR[:picked])
      menu[0][p2] = menu[0][p2].send(MENU_CLR[:picked])
      menu[cur[0]][cur[1]] = menu[cur[0]][cur[1]].send(MENU_CLR[:cur])

      (0..1).each do |row|
        print " " * 10 + " ⚈ ".send(PLR_COLOR[row])
          .send(BRD_COLOR[row]) + menu[row].join("   ")
      end

      # print "            #{"  White: ".red.on_white}  #{menu[0][0]}   #{menu[0][1]}\n"
      # print "            #{"  Black: ".black.on_white}  #{menu[1][0]}   #{menu[1][1]}\n\n"
      # print "                       #{menu[2][0]}   #{menu[2][1]}\n\n"

      input = DraughtsGame.read_char

      case input
      when "\e[A"
        cur = [[cur[0] - 1, 0].max, cur[1]]
      when "\e[D"
        cur = [cur[0], [cur[1] - 1, 0].max]
      when "\e[B"
        cur = [[cur[0] + 1, 2].min, cur[1]]
      when "\e[C"
        cur = [cur[0], [cur[1] + 1, 1].min]
      when "\e"
        exit
      when " ", "\r"
        case cur.row
        when 0                      # select Player 1
          p1 = cur.col
        when 10                     # select Player 2
          p2 = cur.col
        when 2                      # start new game / exit
          exit if cur.col == 10

          return DraughtsGame.new

      end
    end
  end

  #___________________________________________________________________
  private

  def self.read_char
    STDIN.echo = false
    STDIN.raw!

    input = STDIN.getc.chr
    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
  ensure
    STDIN.echo = true
    STDIN.cooked!

    return input
  end
end

# if __FILE__ == $PROGRAM_NAME
#   board = Board.new
#   board.set_up_new_game
#   board.display
# end