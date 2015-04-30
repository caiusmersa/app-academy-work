require_relative 'board.rb'
require_relative 'pos_helper.rb'

require "io/console"

class DraughtsGame
  def self.new_game_from_menu
    p1, p2 = 0, 0
    cur = [2, 0]
    while true
      DraughtsGame.draw_menu(p1, p2, cur)
      input = DraughtsGame.read_char

      case input
      when "\e[A"                                # UP    arrow
        cur = [[cur[0] - 1, 0].max, cur[1]]
      when "\e[B"                                # DOWN  arrow
        cur = [[cur[0] + 1, 2].min, cur[1]]
      when "\e[C"                                # RIGHT arrow
        cur = [cur[0], [cur[1] + 1, 1].min]
      when "\e[D"                                # LEFT  arrow
        cur = [cur[0], [cur[1] - 1, 0].max]
      when "\e"                                  # Esc
        exit
      when " ", "\r"                             # Space / Return
        p1 = cur.col if cur.row == 0
        p2 = cur.col if cur.row == 1
        exit if cur == [2, 1]
        return DraughtsGame.new(nil, nil) if cur == [2, 0]
      end
    end
  end

  #___________________________________________________________________
  private

  def self.draw_menu(p1, p2, cur, l_space = 8, m_space = 3)
    system("clear")
    print "\n\n\n\n"
    menu = [["  Player  ".on_black, " Computer ".on_black],
            ["  Player  ".on_black, " Computer ".on_black],
            ["    OK    ".on_black, "   Exit   ".on_black]]
    # coloring appropriate menu items
    menu[0][p1] = menu[0][p1].send(MENU_COLOR[:picked])
    menu[1][p2] = menu[0][p2].send(MENU_COLOR[:picked])
    menu[cur[0]][cur[1]] = menu[cur[0]][cur[1]]
                           .send(MENU_COLOR[:cur])
    # display player menu rows
    (0..1).each do |row|
      puts " " * l_space + " ⚈ ".send(PLR_COLOR[row])
        .send(BRD_COLOR[row]) + " " + menu[row].join(" " * m_space)
    end
    #display ok/exit menu row
    puts "\n" + " " * (l_space + 4) + menu[2].join(" " * m_space)
  end

  #___________________________________________________________________
  public

  def initialize(player1, player2)
    puts "I'm creating a new game."
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

if __FILE__ == $PROGRAM_NAME
  DraughtsGame.new_game_from_menu
end