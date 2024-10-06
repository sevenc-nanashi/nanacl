# frozen_string_literal: true

# From: https://github.com/universato/ac-library-rb/blob/main/lib/dsu.rb

module Nanacl
  class UnionFindMap
    def initialize(n, default: nil, values: nil, &merge)
      @n = n
      @parent_or_size = Array.new(n, -1)
      # root node: -1 * component size
      # otherwise: parent

      @values =
        if values
          values.dup
        elsif default
          if default.is_a?(Proc)
            Array.new(n, &default) # steep:ignore
          elsif default.is_a?(Integer)
            Array.new(n, default)
          else
            Array.new(n) { default.dup }
          end
        else
          raise ArgumentError.new, "either values or default must be given"
        end # steep:ignore

      @merge = merge
    end

    attr_reader :parent_or_size, :n

    def merge(a, b)
      x = leader(a)
      y = leader(b)
      return x if x == y

      x, y = y, x if -@parent_or_size[x] < -@parent_or_size[y]
      @parent_or_size[x] += @parent_or_size[y]
      @parent_or_size[y] = x

      @values[x] = @merge.call(@values[x], @values[y])
    end
    alias unite merge

    def same?(a, b)
      leader(a) == leader(b)
    end
    alias same same?

    def leader(a)
      unless 0 <= a && a < @n
        raise ArgumentError.new, "#{a} is out of range (0...#{@n})"
      end

      if @parent_or_size[a] < 0
        a
      else
        (@parent_or_size[a] = leader(@parent_or_size[a]))
      end
    end
    alias root leader
    alias find leader

    def [](a)
      @values[leader(a)]
    end
    def []=(a, value)
      @values[leader(a)] = value
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
