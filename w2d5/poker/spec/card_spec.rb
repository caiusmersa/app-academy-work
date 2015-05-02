require 'card'

describe Card do
  subject { Card.new(11, :h) }

  it "has a value" do
    expect(subject.value).to eq(11)
  end

  it "has a suit" do
    expect(subject.suit).to eq(:h)
  end

  it "displays properly for users" do
    expect(subject.to_s).to eq("Jh")
  end
end
