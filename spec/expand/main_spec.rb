# frozen_string_literal: true
require "nanacl/exe/expand/main"
require "rspec/snapshot"
require "open3"

RSpec.describe "CLI: expand" do
  Dir["#{__dir__}/fixture/*"].each do |path|
    it "expands #{path}" do
      $LOAD_PATH << path
      fixture_name = File.basename(path)
      output = "#{__dir__}/output/#{fixture_name}.rb"
      run(["#{path}/main.rb", output])

      result = Open3.capture2e("ruby #{output}")
      expect(result[0]).to match_snapshot("output_#{fixture_name}")
    end
  end
end
