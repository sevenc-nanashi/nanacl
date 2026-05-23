# frozen_string_literal: true
# rubocop:disable Style/GlobalVars
require "ac-library-rb/modint"

$nanacl_factorial_cache = []

module Nanacl
  module Factorial
    module_function

    def prepare(n)
      return if $nanacl_factorial_cache.size > n
      if $nanacl_factorial_cache.empty?
        $nanacl_factorial_cache << 1.to_modint
      end

      ($nanacl_factorial_cache.size..n).each do |i|
        $nanacl_factorial_cache[i] = $nanacl_factorial_cache[i - 1] * i
      end
    end

    def n_permute_k(n, k)
      return 0.to_modint if n < 0 || k < 0 || k > n

      n_permute_k!(n, k)
    end

    def n_permute_k!(n, k)
      if n < 0 || k < 0 || k > n
        raise ArgumentError, "n and k must satisfy 0 <= k <= n"
      end
      prepare(n)
      $nanacl_factorial_cache[n] / $nanacl_factorial_cache[n - k]
    end

    def n_choose_k(n, k)
      return 0.to_modint if n < 0 || k < 0 || k > n

      n_choose_k!(n, k)
    end

    def n_choose_k!(n, k)
      if n < 0 || k < 0 || k > n
        raise ArgumentError, "n and k must satisfy 0 <= k <= n"
      end
      prepare(n)
      $nanacl_factorial_cache[n] /
        ($nanacl_factorial_cache[k] * $nanacl_factorial_cache[n - k])
    end

    def n_multichoose_k(n, k)
      return 0.to_modint if n <= 0 || k < 0

      n_multichoose_k!(n, k)
    end

    def n_multichoose_k!(n, k)
      if n <= 0 || k < 0
        raise ArgumentError, "n must be positive and k must be non-negative"
      end
      n_choose_k(n + k - 1, k)
    end

    def n_multichoose_k_at_least_one(n, k)
      return 0.to_modint if n <= 0 || k < 0 || k < n

      n_multichoose_k_at_least_one!(n, k)
    end

    def n_multichoose_k_at_least_one!(n, k)
      if n <= 0 || k < 0
        raise ArgumentError, "n must be positive and k must be non-negative"
      end
      return 0.to_modint if k < n

      n_choose_k!(k - 1, n - 1)
    end
  end
end

class Integer # rubocop:disable Style/OneClassPerFile
  def factorial
    return 0.to_modint if self < 0

    factorial!
  end

  def factorial!
    if self < 0
      raise ArgumentError, "factorial is not defined for negative numbers"
    end
    Nanacl::Factorial.prepare(self)
    $nanacl_factorial_cache[self]
  end
end

module AcLibraryRb # rubocop:disable Style/OneClassPerFile
  class ModInt
    def factorial
      Nanacl::Factorial.prepare(val)
      $nanacl_factorial_cache[val]
    end
  end
end

# rubocop:enable Style/GlobalVars
