# frozen_string_literal: true
require "English"
require_relative "./libraries"
expand_params = { mode: :blacklist, includes: %w[], excludes: %w[] }

subparser =
  OptionParser.new do |opts|
    opts.banner = "Usage: nanacl expand [options] FILE [OUTPUT]"

    opts.on("-h", "--help", "Prints this help") do
      puts opts
      exit
    end
    opts.on(
      "-m",
      "--mode=MODE",
      "Specify MODE as expand mode. (blacklist or whitelist)"
    ) do |mode|
      expand_params[:mode] = mode.to_sym
      unless %i[blacklist whitelist].include?(expand_params[:mode])
        puts "Invalid mode: #{mode}"
        exit
      end
    end
    opts.on("-i", "--include=LIB", "Specify LIB as include path.") do |lib|
      expand_params[:mode] = :whitelist
      expand_params[:includes] << lib
    end
    opts.on("-e", "--exclude=LIB", "Specify LIB as exclude path.") do |lib|
      expand_params[:excludes] << lib
    end
  end

subparser.parse!(ARGV)

if ARGV.empty?
  puts subparser.help
  exit
end

file = ARGV[0]
output = ARGV[1]

content = +File.read(file)
kept_libraries = Set.new
expanded_libraries = Set.new
errored_libraries = Set.new
nonce = 0
loop do
  expanded = false
  content.gsub!(/require ("|')(.+?)\1/) do |original|
    module_path = $LAST_MATCH_INFO[2]
    if module_path.start_with?("./") || module_path.start_with?("../")
      next original
    end
    package_path = module_path.split("/").first
    should_keep =
      if expand_params[:mode] == :whitelist
        expand_params[:includes].include?(package_path)
      else
        (
          ATCODER_LIBRARIES.include?(package_path) ||
            STD_LIBRARIES.include?(package_path) ||
            expand_params[:excludes].include?(module_path)
        ) && !expand_params[:includes].include?(package_path)
      end
    if should_keep
      kept_libraries << module_path
    else
      expanded_libraries << module_path
      expanded = true
      type, path = $LOAD_PATH.resolve_feature_path(module_path) || [nil, nil]
      if type == :rb && path
        library = File.read(path)
        nonce += 1
        next <<~RUBY
          def __expand__#{nonce}(b) # #{module_path}
            b.eval <<~'INNER_RUBY'
            #{library}
            INNER_RUBY
          end
          __expand__#{nonce}(binding)
          RUBY
      else
        errored_libraries << module_path
      end
    end

    next original
  end
  break unless expanded
end

prefix = output ? "" : "# "
puts "#{prefix}Kept libraries:"
if kept_libraries.empty?
  puts "#{prefix}  (none)"
else
  kept_libraries.each { |lib| puts "#{prefix}- #{lib}" }
end
puts "#{prefix}Expanded libraries:"
if expanded_libraries.empty?
  puts "#{prefix}  (none)"
else
  expanded_libraries.each { |lib| puts "#{prefix}- #{lib}" }
end
puts "#{prefix}Errored libraries:"
if errored_libraries.empty?
  puts "#{prefix}  (none)"
else
  errored_libraries.each { |lib| puts "#{prefix}- #{lib}" }
end
content.insert(0, "# This file is expanded by nanacl.\n")
if output
  File.write(output, content)
else
  puts "#"
  puts "# #{"-" * 78}"
  puts ""
  puts content
end
