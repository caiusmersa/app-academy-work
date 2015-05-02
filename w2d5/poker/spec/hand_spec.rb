require 'hand'

describe Hand do
  (2..14).each do |value|
    ['h', 's', 'd', 'c'].each do |suit|
      let(("c" + value.to_s + suit).to_sym) { Card.new(value, suit.to_sym) }
    end
  end

  let(:str_flush_hand)       { Hand.new([ c6h, c3h, c4h, c5h, c2h]) }
  let(:ace_low_str_flush)    { Hand.new([c14h, c3h, c4h, c5h, c2h]) }
  let(:royal_flush_hand)     { Hand.new([c14h,c11h,c13h,c12h,c10h]) }
  let(:four_hand)            { Hand.new([ c6h, c6s, c6c, c6d,c10h]) }
  let(:four_hand_v2)         { Hand.new([ c8h, c8s, c8c, c8d,c10h]) }
  let(:full_house)           { Hand.new([ c7h, c7d, c7s,c12h,c12d]) }
  let(:flush)                { Hand.new([c14h,c10h,c13h,c12h, c7h]) }
  let(:straight)             { Hand.new([ c3d, c4s, c5c, c6h, c7h]) }
  let(:ace_low_str)          { Hand.new([c14c, c2c, c3d, c4s, c5c]) }
  let(:three_kind)           { Hand.new([ c7h, c7d, c7s, c9h, c6s]) }
  let(:two_pair)             { Hand.new([ c6h, c6d, c7h, c7s,c10h]) }
  let(:two_pair2)            { Hand.new([ c5h, c5d, c7h, c7s,c10h]) }
  let(:two_pair3)            { Hand.new([ c5h, c5d, c7h, c7s,c14h]) }
  let(:pair)                 { Hand.new([ c6h, c6s,c13h,c12h,c10h]) }
  let(:high_card)            { Hand.new([ c8h,c11d,c10c,c9s, c14h]) }

  describe "Picks the right winner" do
    it "picks a royal flush as the winner" do
      expect(royal_flush_hand > four_hand).to be true
    end

    it "tells us a straight flush loses to a royal flush" do
      expect(str_flush_hand > royal_flush_hand).to be false
    end

    it "correctly compares four of a kind hands" do
      expect(four_hand_v2 > four_hand).to be true
    end

    it "correctly compares two pair hands" do
      expect(two_pair > two_pair2).to be true
    end

    it "correctly picks a two pair winner with high kicker" do
      expect(two_pair3 < two_pair).to be true
      expect(two_pair3 > two_pair2).to be true
    end

    it "correctly picks a winner between two straights with aces low or high" do
      expect(ace_low_str < straight).to be true
    end

    it "detects equal hands" do
      expect(two_pair == two_pair).to be true
    end
  end

  describe "Detects correct poker hand" do
    context "Straight flush" do
      it "detects a non-royal straight flush" do
        expect(str_flush_hand.value).to eq STR_FLUSH
        expect(ace_low_str_flush.value).to eq STR_FLUSH
      end

      it "detects a royal flush" do
        expect(royal_flush_hand.value).to eq STR_FLUSH
      end
    end

    context "Four of a kind" do
      it "detects a Four of a kind" do
        expect(four_hand.value).to eq FOUR_KIND
      end
    end

    context "Full House" do
      it "detects a Full House" do
        expect(full_house.value).to eq FULL_HOUSE
      end
    end

    context "Flush" do
      it "detects a Flush" do
        expect(flush.value).to eq FLUSH
      end
    end

    context "Straight" do
      it "detects a Straight" do
        expect(straight.value).to eq STRAIGHT
      end

      it "detects an ace low straight" do
        expect(ace_low_str.value).to eq STRAIGHT
      end
    end

    context "Three of a kind" do
      it "detects a Three of a kind" do
        expect(three_kind.value).to eq THREE_KIND
      end
    end

    context "Two pair" do
      it "detects a Two pair" do
        expect(two_pair.value).to eq TWO_PAIR
      end
    end

    context "Pair" do
      it "detects a Pair" do
        expect(pair.value).to eq PAIR
      end
    end

    context "High card" do
      it "detects a High card" do
        expect(high_card.value).to eq HIGH_CARD
      end
    end
  end
end
