# frozen_string_literal: true
require "nanacl/exe/expand/main"
require "rspec/snapshot"
require "open3"

RSpec.describe "CLI: expand" do
  [
    ["atcoder", %w[-p atcoder]],
    ["vanilla", %w[-p vanilla]]
  ].each do |name, args|
    describe args.join(" ") do
      Dir["#{__dir__}/fixture/*"].each do |path|
        before { allow($stdout).to receive(:puts) }

        it "expands #{path}" do
          $LOAD_PATH << "#{path}/lib"
          fixture_name = File.basename(path)
          output = "#{__dir__}/output/#{fixture_name}.rb"
          run(["#{path}/main.rb", output, *args])

          result = Open3.capture2("ruby #{output}")
          expect(result[1]).to be_success

          expect(result[0].chomp).to match_snapshot(
            "stdout_#{name}_#{fixture_name}"
          )
          expect(File.read(output)).to match_snapshot(
            "output_#{name}_#{fixture_name}"
          )
        ensure
          $LOAD_PATH.pop
        end
      end
    end
  end
end
