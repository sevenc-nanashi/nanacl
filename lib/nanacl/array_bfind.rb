# frozen_string_literal: true

class Array
  def binary_find(target)
    range =
      (
        if target.is_a?(Range)
          target
        else
          (target..target)
        end
      )

    start = bsearch_index { |x| x >= range.begin }
    finish =
      if range.exclude_end?
        bsearch_index { |x| x >= range.end }
      else
        bsearch_index { |x| x > range.end }
      end
    start = size if start.nil?
    finish = size + 1 if finish.nil?
    [start, finish - 1]
  end
end
