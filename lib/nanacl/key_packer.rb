# frozen_string_literal: true

module Nanacl
  class KeyPacker
    def initialize(*maxes)
      @maxes = maxes
    end

    def pack(*values)
      raise ArgumentError, "number of values must match number of maxes" if values.size != @maxes.size

      key = 0
      multiplier = 1
      @maxes.each_with_index do |max, i|
        value = values[i]
        raise ArgumentError, "value #{value} exceeds max #{max}" if value < 0 || value > max

        key += value * multiplier
        multiplier *= (max + 1)
      end
      key
    end

    def unpack(key)
      values = []
      multiplier = 1
      @maxes.each do |max|
        value = (key / multiplier) % (max + 1)
        values << value
        multiplier *= (max + 1)
      end
      values
    end
  end
end
