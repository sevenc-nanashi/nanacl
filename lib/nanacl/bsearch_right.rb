# frozen_string_literal: true

class Array
  def bsearch_right(&block)
    index = bsearch_index_right(&block)
    index && self[index]
  end

  def bsearch_index_right(&block)
    right = bsearch_index { |elem| !block.call(elem) }
    if right == nil
      size - 1
    elsif right == 0
      nil
    else
      right - 1
    end
  end
end

class Range
  def bsearch_right(&block)
    right = bsearch { |elem| !block.call(elem) }
    if right == nil
      last
    elsif right == first
      nil
    else
      right - 1
    end
  end
end
