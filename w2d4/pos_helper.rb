D_ROW = { :p1 => 1, :p2 => -1 }

BRD_COLOR = { 0 => :on_light_magenta, 1=> :on_magenta }
PLR_COLOR  = { :p1 => :blue, 0 => :blue, :p2 => :light_red, 1 => :light_red nil => :black }
RLR_COLOR = { :back => :on_light_green, :text => :light_black }
MENU_COLOR = { :cur => :on_yellow, :picked => :cyan }

COORD_ROW = ["X", "9", "8", "7", "6", "5", "4", "3", "2", "1"]
COORD_COL = ("a".."j").map { |char| " " + char + " "}

class Array
  def row
    self[0]
  end

  def col
    self[1]
  end

  def on?(board)
    board.on?(row, col)
  end
end 