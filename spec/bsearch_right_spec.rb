# frozen_string_literal: true
require "nanacl/bsearch_right"

RSpec.describe "bsearch_right" do
  describe "Array#bsearch_right, Array#bsearch_index_right" do
    it "can find the rightmost element" do
      array = %w[a a b b d d e e]
      expect(array.bsearch_right { |x| x <= "c" }).to eq("b")
      expect(array.bsearch_index_right { |x| x <= "c" }).to eq(3)
    end

    it "returns nil if not found" do
      array = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5]
      expect(array.bsearch_right { |x| x >= 6 }).to be_nil
      expect(array.bsearch_index_right { |x| x >= 6 }).to be_nil
    end

    it "works when all elements return false" do
      array = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5]
      expect(array.bsearch_right { |x| x < 1 }).to be_nil
      expect(array.bsearch_index_right { |x| x < 1 }).to be_nil
    end
  end

  describe "Range#bsearch_right" do
    it "can find the rightmost element" do
      range = 1..5
      expect(range.bsearch_right { |x| x >= 3 }).to eq(5)
    end

    it "returns nil if not found" do
      range = 1..5
      expect(range.bsearch_right { |x| x >= 6 }).to be_nil
    end

    it "works when all elements return false" do
      range = 1..5
      expect(range.bsearch_right { |x| x < 1 }).to be_nil
    end
  end
end
