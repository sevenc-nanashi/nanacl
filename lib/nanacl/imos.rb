# frozen_string_literal: true

module Nanacl
  class Imos
    def initialize(size)
      @size = size
      @data = Array.new(size + 1, 0)
    end

    def add(range, value)
      l = range.begin || 0
      r = range.end || @size
      r -= 1 if range.exclude_end?
      raise ArgumentError, "range out of bounds" if l < 0 || r >= @size || l > r

      @data[l] += value
      @data[r + 1] -= value if r + 1 <= @size
    end

    def build
      (1..@size).each do |i|
        @data[i] += @data[i - 1]
      end
      @data.pop
      @data
    end

    alias to_a build
  end
end
