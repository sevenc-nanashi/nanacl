# frozen_string_literal: true
require "nanacl/imos"

RSpec.describe "Nanacl.imos" do
  it "works with small array" do
    imos = Nanacl::Imos.new(5)
    imos.add(1..3, 2)
    imos.add(2..4, 3)
    expect(imos.build).to eq([0, 2, 5, 5, 3])
  end

  it "works with edge cases" do
    imos = Nanacl::Imos.new(5)
    imos.add(0..4, 1)
    imos.add(0...5, 2)
    expect(imos.to_a).to eq([3, 3, 3, 3, 3])
  end

  it "raises error with out of bounds range" do
    imos = Nanacl::Imos.new(5)
    expect { imos.add(-1..3, 2) }.to raise_error(ArgumentError)
    expect { imos.add(1..5, 2) }.to raise_error(ArgumentError)
    expect { imos.add(3..1, 2) }.to raise_error(ArgumentError)
  end
end
