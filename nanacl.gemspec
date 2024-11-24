# frozen_string_literal: true

require_relative "lib/nanacl/version"

Gem::Specification.new do |spec|
  spec.name = "nanacl"
  spec.version = Nanacl::VERSION
  spec.authors = ["sevenc-nanashi"]
  spec.email = ["sevenc7c@sevenc7c.com"]

  spec.summary = "自分用AtCoderライブラリ"
  spec.homepage = "https://github.com/sevenc-nanashi/nanacl"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "ac-library-rb", "~> 1.2.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
spec.metadata["rubygems_mfa_required"] = "true"
end
