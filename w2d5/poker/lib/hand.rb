STR_FLUSH = 8
FOUR_KIND = 7
FULL_HOUSE = 6
FLUSH = 5
STRAIGHT = 4
THREE_KIND = 3
TWO_PAIR = 2
PAIR = 1
HIGH_CARD = 0

class Hand
  include Comparable
  attr_reader :cards

  def initialize(cards)
    @cards = cards
    straighten!
  end

  def <=>(other)
    value == other.value ? value_orders <=> other.value_orders : value <=> other.value
  end

  def value
    if straight? && flush?
      STR_FLUSH
    elsif value_counts == [4, 1]
      FOUR_KIND
    elsif value_counts == [3, 2]
      FULL_HOUSE
    elsif flush?
      FLUSH
    elsif straight?
      STRAIGHT
    elsif value_counts == [3, 1, 1]
      THREE_KIND
    elsif value_counts == [2, 2, 1]
      TWO_PAIR
    elsif value_counts == [2, 1, 1, 1]
      PAIR
    else
      HIGH_CARD
    end
  end

  protected

  def value_orders
    value_hash.to_a.sort_by { |el| el.last * 15 + el.first }.map(&:first).reverse
  end

  def value_counts
    value_hash.values.sort.reverse
  end

  private

  def value_hash
    cards.map(&:value).each_with_object(Hash.new(0)){ |v, h| h[v] += 1 }
  end

  def straighten!
    cards.find { |card| card.value == 14 }.value = 1 if value_orders == [14, 5, 4, 3, 2]
  end

  def straight?
    sorted = cards.map(&:value).sort
    (0..3).each { |idx| return false unless sorted[idx] + 1 == sorted[idx+1] }
    true
  end

  def flush?
    cards.map { |card| card.suit }.uniq.count == 1
  end
end
