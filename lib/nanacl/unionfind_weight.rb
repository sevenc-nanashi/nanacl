# frozen_string_literal: true

# From: https://github.com/universato/ac-library-rb/blob/main/lib/dsu.rb

module Nanacl
  class UnionFindWeight
    def initialize(n, default_weight: 0)
      @n = n
      @parent_or_size = Array.new(n, -1)
      # root node: -1 * component size
      # otherwise: parent

      @diff_weight = Array.new(n, default_weight)
    end

    attr_reader :parent_or_size, :n

    def merge(a, b, w)
      x = leader(a)
      y = leader(b)
      return x if x == y

      w = weight(a) - weight(b) + w
      if -@parent_or_size[x] < -@parent_or_size[y]
        x, y = y, x
        w = -w
      end
      @parent_or_size[x] += @parent_or_size[y]
      @parent_or_size[y] = x
      @diff_weight[y] = w
    end
    alias unite merge

    def same?(a, b)
      leader(a) == leader(b)
    end
    alias same same?

    def weight(a)
      leader(a)
      @diff_weight[a]
    end

    def diff(a, b)
      leader(a)
      leader(b)
      @diff_weight[b] - @diff_weight[a]
    end

    def leader(a)
      unless 0 <= a && a < @n
        raise ArgumentError.new, "#{a} is out of range (0...#{@n})"
      end

      if @parent_or_size[a] < 0
        a
      else
        root = leader(@parent_or_size[a])
        @diff_weight[a] += @diff_weight[@parent_or_size[a]]
        @parent_or_size[a] = root
      end
    end
    alias root leader
    alias find leader

    def [](a)
      if @n <= a
        @parent_or_size.concat([-1] * (a - @n + 1))
        @n = @parent_or_size.size
      end

      if @parent_or_size[a] < 0
        a
      else
        (@parent_or_size[a] = self[@parent_or_size[a]])
      end
    end

    def size(a)
      -@parent_or_size[leader(a)]
    end

    def groups
      (0...@parent_or_size.size).group_by { |i| leader(i) }.values
    end

    def to_s
      "<#{self.class}: @n=#{@n}, #{@parent_or_size}>"
    end
  end
end
