class Card  
  VALUE_HASH = {
    1  => "A",
    14 => "A",
    13 => "K",
    12 => "Q",
    11 => "J"
  }
  attr_reader :suit
  attr_accessor :value

  def initialize(value, suit)
    @suit = suit
    @value = value
  end

  def to_s
    "#{VALUE_HASH.has_key?(value) ? VALUE_HASH[value] : value}#{suit.to_s}"
  end
end
