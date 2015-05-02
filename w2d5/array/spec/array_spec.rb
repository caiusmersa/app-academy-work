require 'array'

describe Array do
  describe "#my_uniq" do
    let(:array) { [1,1,2,2,3,3,5] }

    it "returns a 'uniqued' array" do
      expect(array.my_uniq).to eq [1,2,3,5]
    end
  end

  describe "#two_sum" do
    subject { [2,-2, 5, 3,-3, 0] }

    it "returns correct indices" do
      expect(subject.two_sum).to eq [[0,1], [3,4]]
    end
  end

  describe "#my_transpose" do
    subject {
      [[0, 1, 2],
       [3, 4, 5],
       [6, 7, 8]]}

    it "returns a transposed matrix" do
      expect(subject.my_transpose).to eq subject.transpos
    end
  end


end
