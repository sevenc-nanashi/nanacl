# frozen_string_literal: true

require "rspec"
require "nanacl/rhash"

RSpec.describe "rolling_hash" do
  def naive_hash(bytes, base, mod)
    bytes.reduce(0) { |acc, byte| ((acc * base) + byte) % mod }
  end

  describe "#append" do
    it "ウィンドウ内の要素から計算したハッシュ値を返す" do
      base = 257
      mod = (2**61) - 1
      window_size = 3
      values = [1, 2, 3, 4, 5]

      rhash = Nanacl::RollingHash.new(window_size, base:, mod:)
      window = []
      actual = []
      expected = []

      values.each do |value|
        actual << rhash.append(value)
        window.shift if window.size == window_size
        window << value
        expected << naive_hash(window, base, mod)
      end

      expect(actual).to eq(expected)
    end

    it "mod を跨いでも正しくハッシュ値を更新する" do
      base = 5
      mod = 19
      window_size = 2
      values = [7, 11, 13, 17]

      rhash = Nanacl::RollingHash.new(window_size, base:, mod:)
      window = []

      values.each do |value|
        current = rhash.append(value)
        window.shift if window.size == window_size
        window << value
        expect(current).to eq(naive_hash(window, base, mod))
      end
    end
  end
end
