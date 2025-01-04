# frozen_string_literal: true
require "nanacl/rooti"

RSpec.describe "Nanacl.rooti" do
  [
    [16, 2, 4],
    [16, 3, 2],
    [16, 4, 2],
    [16, 5, 1],
    [32**2, 2, 32],
    [1000**3, 3, 1000]
  ].each do |(value, base, expected)|
    it "works with value=#{value}, base=#{base}" do
      expect(Nanacl.rooti(value, base)).to eq(expected)
    end
  end
end
