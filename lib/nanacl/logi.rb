# frozen_string_literal: true

module Nanacl
  module_function

  def logi(value, base)
    maybe_accurate = Math.log(value, base).floor
    if base**maybe_accurate > value
      maybe_accurate - 1
    elsif base**(maybe_accurate + 1) <= value
      maybe_accurate + 1
    else
      maybe_accurate
    end
  end
end
