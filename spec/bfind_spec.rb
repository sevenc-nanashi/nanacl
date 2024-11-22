# frozen_string_literal: true
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

  it "works with range whose start is over the last element" do
    array = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5]
    expect(array.binary_find(6..7)).to be_nil
  end

  it "works with range whose end is over the last element" do
    array = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5]
    expect(array.binary_find(4..6)).to eq([6, 9])
  end

  it "works with range which is between two elements" do
    array = [1, 1, 2, 2, 3, 3, 6, 6, 9, 9]
    expect(array.binary_find(4..5)).to be_nil
  end

  it "works with startless range" do
    array = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5]
    expect(array.binary_find(..3)).to eq([0, 5])
  end

  it "works with endless range" do
    array = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5]
    expect(array.binary_find(3..)).to eq([4, 9])
  end

  it "returns nil if not found" do
    array = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5]
    expect(array.binary_find(6)).to be_nil
  end
end
