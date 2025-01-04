# frozen_string_literal: true

module Nanacl
  module_function

  def rooti(value, base)
    maybe_accurate = (value**(1.0 / base)).floor
    if (maybe_accurate - 1)**base >= value
      maybe_accurate - 1
    elsif (maybe_accurate + 1)**base <= value
      maybe_accurate + 1
    else
      maybe_accurate
    end
  end

  def sqrti(value)
    rooti(value, 2)
  end
end
