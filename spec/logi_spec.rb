# frozen_string_literal: true
require "nanacl/logi"

RSpec.describe "Nanacl.logi" do
  [[1, 2, 0], [2**5, 2, 5], [2**5 - 1, 2, 4]].each do |(value, base, expected)|
    it "works with value=#{value}, base=#{base}" do
      expect(Nanacl.logi(value, base)).to eq(expected)
    end
  end

  (2..16).map do |i|
    it "works with base=#{i} and its neighbors" do
      [
        [i**i - 1, i, i - 1],
        [i**i, i, i],
        [i**i + 1, i, i]
      ].each do |(value, base, expected)|
        expect(Nanacl.logi(value, base)).to eq(expected)
      end
    end
  end

  [[(1 << 49) - 1, 2, 48], [2**60 - 1, 2, 59]].each do |(value, base, expected)|
    it "is more accurate than Math.log.floor with value=#{value}, base=#{base}" do
      expect(Math.log(value, base).floor).not_to eq(expected)
      expect(Nanacl.logi(value, base)).to eq(expected)
    end
  end
end
