# frozen_string_literal: true

module Nanacl
  module_function

  def rooti(value, base)
    return -1 if value < 0
    return 0 if value == 0
    return 1 if value == 1
    maybe_accurate = (value**(1.0 / base)).floor - 1
    maybe_accurate += 1 until (maybe_accurate + 1)**base > value
    maybe_accurate
  end

  def sqrti(value)
    rooti(value, 2)
  end
end
