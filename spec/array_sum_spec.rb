# frozen_string_literal: true
require "rspec"
require "nanacl/array_sum"

RSpec.describe "Array#sum_in_range" do
  it "works with inclusive end" do
    array = [1, 2, 3, 4, 5]
    expect(array.sum_in_range(1..3)).to eq(9)
    expect(array.sum_in_range(0..3)).to eq(10)
  end

  it "works with exclusive end" do
    array = [1, 2, 3, 4, 5]
    expect(array.sum_in_range(1...3)).to eq(5)
  end

  it "works with nil end" do
    array = [1, 2, 3, 4, 5]
    expect(array.sum_in_range(1..)).to eq(14)
  end
end
