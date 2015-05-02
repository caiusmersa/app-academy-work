require_relative 'deck.rb'

class Player
  attr_reader :deck, :hand, :wallet
  def initialize(deck, wallet = 1000)
    puts "Please input a player name: "
    @name = gets.chomp
    @deck = deck
    @wallet = wallet
    @hand = []
  end

  def bet(match)
    puts "#{@name.capitalize}, please input bet amount (bet to match is #{match}): "
    begin
      bet = Integer(gets)
      raise BetError.new("Bet needs to be at least #{match}!") unless bet >= match
      @wallet -= bet
    rescue ArgumentError
      puts "Please input a number for your bet!"
    rescue BetError => e
      puts e.message
    end
    bet
  end

  def raise

  end

  def take_cards
    @hand = @deck.draw(5)
  end

  def take_pot(pot)
    @wallet += pot
  end
end

class BetError < StandardError
end
