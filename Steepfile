# frozen_string_literal: true
D = Steep::Diagnostic

target :lib do
  signature "sig"

  check "lib"
  check "Gemfile"
  ignore "lib/nanacl/exe"
  configure_code_diagnostics(D::Ruby.default)
end

target :test do
  signature "sig"

  check "spec"
end

# vim: ft=ruby
