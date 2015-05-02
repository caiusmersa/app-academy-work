class PokerGame
  def initialize
    # puts "Poker in the Terminal doesn't work. Goodbye!"
    @deck = Deck.new
    player1 = Player.new(@deck)
    player2 = Player.new(@deck)
    player3 = Player.new(@deck)
    @players = [player1, player2, player3]
    @pot = 0
  end

  def play

  end

  def round

  end
end
