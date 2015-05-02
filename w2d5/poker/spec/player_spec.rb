require 'player'

describe Player do
  let(:deck) { Deck.new }
  subject { Player.new(deck) }

  it "Knows what a deck is" do
    expect(subject.deck).to be_a Deck
  end

  it "can take cards" do
    subject.take_cards
    expect(subject.hand).to be_a Array
  end

  it "knows how to take money" do
    subject.take_pot(1000)
    expect(subject.wallet).to eq 2000
  end
end
