
require './board.rb'

class Piece
  attr_accessor :pos, :has_moved
  attr_reader :color, :board

  def initialize(pos, board, color)
    @pos = pos
    @board = board
    @color = color
    @has_moved = false
  end

  def display
    raise ChessError.new("Unimplemented method")
  end

  def make_move(end_pos)
    if valid_moves.include?(end_pos)
      #dupe the board and make the move on the duped board
      # unless duped_bboard.in_check(color)
      board.update_square(pos, end_pos)
      self.pos = end_pos
      self.has_moved = true
    end
  end

  def piece_moves
    raise ChessError.new("Unimplemented method")
  end

  def valid_moves
    piece_moves.select { |new_pos| (0..7).include?(new_pos[0]) &&
                                   (0..7).include?(new_pos[1]) }
  end
end

class SteppingPiece < Piece
  def piece_moves
    self.class.deltas.map { |move| [pos[0] + move[0], pos[1] + move[1]]}
      .reject {|move|   @board.square(move) &&
                        @board.square(move).color == color }
  end
end

class Knight < SteppingPiece
  def self.deltas
    @delta= [
        [-2, 1],  [-1, 2],  [1, 2],  [2, 1],
        [-2, -1], [-1, -2], [1, -2], [2, -1]
      ]
  end

  def display
    "♞"
  end
end

class King < SteppingPiece
  def self.deltas
    @delta= [
        [-1, 1],  [0, 1],  [1, 1],
        [-1, 0],           [1, 0],
        [-1, -1], [0, -1], [1, -1]
      ]
  end

  def display
    "♚"
  end
end

class SlidingPiece < Piece
  ######
  def piece_moves

    # self.class.deltas.map { |move| [pos[0] + move[0], pos[1] + move[1]]}
  end

  def sliding_moves(deltas)
    all_moves = []

    deltas.each do |delta|
      (1..7).each do |increment|
        next_x = pos[0] + delta[0] * increment
        next_y = pos[1] + delta[1] * increment
        next_pos = [next_x, next_y]
        all_moves << next_pos unless  @board.square(next_pos) &&
                                      @board.square(next_pos).color == color
        break if @board.square(next_pos)
      end
    end

    all_moves
  end

  def rook_moves
    sliding_moves( [[-1, 0], [1, 0], [0, -1], [0, 1]] )
  end


  def bishop_moves
    sliding_moves( [[1, 1], [1, -1], [-1, 1], [-1,-1]] )
  end

  # def sliding_moves(deltas)
  #   deltas.each
  # end
end

class Queen < SlidingPiece
  def display
    "♛"
  end

  def piece_moves
    rook_moves + bishop_moves
  end
end

class Rook < SlidingPiece
  def display
    "♜"
  end

  def piece_moves
    rook_moves
  end
end

class Bishop < SlidingPiece
  def display
    "♝"
  end

  def piece_moves
    bishop_moves
  end
end

class Pawn < Piece
  def display
    "♟"
  end

  def piece_moves
    all_moves = []
    dy = color == :B ? 1 : -1

    front_one_pos = [pos[0] + dy, pos[1]]
    front_two_pos = [pos[0] + dy + dy, pos[1]]
    cap_positions = [ [pos[0] + dy, pos[1] + 1], [pos[0] + dy, pos[1] - 1] ]


    all_moves << front_one_pos unless @board.square(front_one_pos)
    all_moves << front_two_pos unless @board.square(front_one_pos) ||
                                      @board.square(front_two_pos) ||
                                      has_moved

    cap_positions.each do |cap_pos|
      all_moves << cap_pos if @board.square(cap_pos) &&
                              @board.square(cap_pos).color != color
    end

    all_moves
  end

  def make_move(end_pos)
    super(end_pos)
    #check for promotion
  end
end

class ChessError < RuntimeError
end
