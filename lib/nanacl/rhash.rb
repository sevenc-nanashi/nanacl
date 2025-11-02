# frozen_string_literal: true

module Nanacl
  class RollingHash
    def initialize(window_size, base: 257, mod: (2**61) - 1)
      @window_size = window_size
      @base = base
      @mod = mod
      @base_window_size = pow_mod(base, [window_size - 1, 0].max, mod)
      @hash = 0
      @window = []
    end

    def append(byte)
      if @window.size == @window_size
        old_byte = @window.shift
        @hash = (@hash - (old_byte * @base_window_size)) % @mod
      end
      @window << byte
      @hash = ((@hash * @base) + byte) % @mod
      @hash
    end

    private

    def pow_mod(base, exp, mod)
      result = 1
      base %= mod
      while exp > 0
        result = (result * base) % mod if exp.odd?
        exp >>= 1
        base = (base * base) % mod
      end
      result
    end
  end
end
