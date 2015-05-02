require 'deck'
require 'card'

describe Deck do
  subject(:deck) { Deck.new }

  it "returns an Array of cards when you draw from it" do
    expect(deck.draw).to be_a Array
    expect(deck.draw.sample).to be_a Card
  end

  it "removes a card from the deck when you draw it" do
    cards = deck.draw(5)
    cards.each { |card| expect(deck.cards.include?(card)).to be false }
  end

  it "shuffles the deck" do
    deck.generate.shuffle!
    cards1 = deck.draw(10)
    deck.generate.shuffle!
    cards2 = deck.draw(10)
    expect(cards1).not_to eq(cards2)
  end
end
