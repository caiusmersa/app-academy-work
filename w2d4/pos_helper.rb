D_ROW = { :p1 => 1, :p2 => -1 }

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