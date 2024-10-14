# frozen_string_literal: true
class Array
  def sum_in_range(range)
    unless @sums
      @sums = [0]
      sum = 0
      each { |v| @sums << (sum += v) }
    end
    if range.end.nil?
      @sums[length] - @sums[range.begin]
    elsif range.exclude_end?
      @sums[range.end] - @sums[range.begin]
    else
      @sums[range.end + 1] - @sums[range.begin]
    end
  end
end
