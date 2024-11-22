# frozen_string_literal: true

class Array
  def binary_find(target)
    if target.is_a?(Range)
      start = target.begin.nil? ? 0 : bsearch_index { |x| x >= target.begin }
      finish =
        if target.end.nil?
          size
        elsif target.exclude_end?
          bsearch_index { |x| x >= target.end }
        else
          bsearch_index { |x| x > target.end }
        end
      return nil if start.nil?
      return start, (size - 1) if finish.nil?
      return nil if finish <= start
    else
      start = bsearch_index { |x| x >= target }
      finish = bsearch_index { |x| x > target }
      return nil if start.nil? || finish.nil? || finish <= start
    end
    [start, finish - 1]
  end
end
