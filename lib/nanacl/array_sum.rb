# frozen_string_literal: true
class Array
  def sum_in_range(range)
    unless @sums
      @sums = [0]
      sum = 0
      each { |v| @sums << (sum += v) }
    end
    range_begin = range.begin || 0
    if range.end.nil?
      @sums[length] - @sums[range_begin]
    elsif range.exclude_end?
      @sums[range.end] - @sums[range_begin]
    else
      @sums[range.end + 1] - @sums[range_begin]
    end
  end
end
