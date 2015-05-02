require_relative 'card.rb'

class Deck

  def initialize
    generate
  end

  def cards
    @cards.dup
  end

  def draw(num = 1)
    @cards.pop(num)
  end

  def generate
    @cards = []
    (2..14).each do |value|
      [:h, :s, :d, :c].each do |suit|
        @cards << Card.new(value, suit)
      end
    end
    self
  end

  def shuffle!
    @cards.shuffle
  end
end
