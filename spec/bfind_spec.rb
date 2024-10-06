require "nanacl/array_bfind"

RSpec.describe "Array#binary_find" do
  it "works with value" do
    array = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5]
    expect(array.binary_find(2)).to eq([2, 3])
  end

  it "works with range" do
    array = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5]
    expect(array.binary_find(2..3)).to eq([2, 5])
  end
end
