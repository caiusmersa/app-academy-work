
require_relative 'board.rb'

class Piece
  attr_accessor :pos, :has_moved
  attr_reader :color, :board

  def initialize(pos, board, color, has_moved = false)
    @pos = pos
    @board = board
    @color = color
    @has_moved = has_moved
  end

  def deep_dup(new_board)
    self.class.new(pos.dup, new_board, color, has_moved)
  end

  def display
    raise ChessError.new("Unimplemented method")
  end

  def make_move(end_pos)
    if valid_moves.include?(end_pos)
      #dupe the board and make the move on the duped board
      # unless duped_bboard.in_check(color)
      make_move!(end_pos)
      board.player_turn = board.opp_color(color)
      board.selected_piece = nil
      @board.count += 1
      return true
    end

    false
  end

  def make_move!(end_pos)
    board.update_square(pos, end_pos)
    self.pos = end_pos
    self.has_moved = true

    #remove en passant possibilities
    (board.all_pieces(:B) + board.all_pieces(:W))
      .select { |piece| piece.class == Pawn }
      .each   { |pawn|  pawn.just_moved_two = false }
  end

  def piece_moves
    raise ChessError.new("Unimplemented method")
  end

  def valid_moves
    spaces_threatened.reject do |move|
      duped_board = @board.deep_dup
      duped_piece = duped_board.square(pos)
      duped_piece.make_move!(move)
      duped_board.in_check?(color)
    end
  end

  def spaces_threatened
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

  def valid_moves
    reg_moves = super
    if !has_moved
      opp_attacks = @board.all_pieces(@board.opp_color(color))
        .map    { |piece| piece.spaces_threatened }
        .inject(&:+)
      k_row = pos.first
      @board.all_pieces(color).select { |piece| piece.class == Rook }.each do |rook|
        case rook.pos
        when [k_row, 7]
          in_between = [[k_row, 6], [k_row, 5]]
        when [k_row, 0]
          in_between = [[k_row, 2], [k_row, 3], [k_row, 1]]
        else
          in_between = []
        end
        unless in_between.empty? || rook.has_moved ||
               in_between.any? { |p| board.square(p) } ||
               in_between.take(2).any? { |p| opp_attacks.include?(p) }
          reg_moves << in_between.first
        end
      end
    end

    reg_moves
  end

  def make_move!(end_pos)
    if end_pos[1] - pos[1] > 1
      rook = @board.square([pos[0], 7])
      rook.make_move!([pos[0], 5])
    elsif end_pos[1] - pos[1] < -1
      rook = @board.square([pos[0], 0])
      rook.make_move!([pos[0], 3])
    end

    super
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
  attr_accessor :just_moved_two

  def initialize(pos, board, color, has_moved = false)
    super
    just_moved_two = false
  end

  def display
    "♟"
  end
  #
  # def valid_moves
  #   reg_moves = super
  #
  #   if pos[0] == (color == :W ? 3 : 4)
  #     adjacent_pcs = [ @board.square([pos[0], pos[1] + 1]),
  #                      @board.square([pos[0], pos[1] - 1]) ]
  #     adjacent_pcs.each do |piece|
  #       if piece && piece.class == Pawn && piece.just_moved_two
  #         reg_moves << [pos[0] + color == :W  ? (-1) : (1), piece.pos[1]]
  #       end
  #     end
  #   end
  #
  #   reg_moves
  # end

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

  def make_move!(end_pos)
    # if pos[2]
    if end_pos[0] == (color == :B ? 7 : 0)
      @board.set_square(end_pos, Queen.new(end_pos, @board, color, true))
      @board.set_square(pos, nil)
    else
      super
    end
    just_moved_two = true if (pos[1] - end_pos[1]).abs == 2
  end
end

class ChessError < RuntimeError
end
