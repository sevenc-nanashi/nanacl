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
content = <<~RUBY
main = -> do
#{content}
end
RUBY
kept_libraries = Set.new
expanded_libraries = Set.new
errored_libraries = Set.new
removed_libraries = Set.new
nonce = 0
loop do
  libraries = []
  content.gsub!(/^require ("|')(.+?)\1( # nanacl:remove)?/) do |original|
    if $LAST_MATCH_INFO[3]
      removed_libraries << $LAST_MATCH_INFO[2]
      next original
    end
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
      type, path = $LOAD_PATH.resolve_feature_path(module_path) || [nil, nil]
      if type == :rb && path
        library = File.read(path)
        nonce += 1
        header = "# == #{module_path} "
        libraries << <<~LIBRARY
        #{header.ljust(80, "-")}
        #{library}
        LIBRARY

        next "# #{original} (expanded: $#{module_path}$)"
      else
        errored_libraries << module_path
      end
    end

    next original
  end

  break if libraries.empty?
  unless content.include?("# === dependencies ")
    content += "\n"
    content += "# === dependencies ".ljust(80, "-")
    content += "\n"
  end
  content += libraries.join("\n")
end
content.insert(0, "# This file is expanded by nanacl.\n")
content.insert(0, "# frozen_string_literal: true\n")
content += "\nmain.call\n"
content =
  content.gsub(/\$([^$]+)\$/) do
    line_number = content.lines.find_index { |line| line.include?("# == #{$LAST_MATCH_INFO[1]} ") } + 1
    "L#{line_number}"
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
puts "#{prefix}Removed libraries:"
if removed_libraries.empty?
  puts "#{prefix}  (none)"
else
  removed_libraries.each { |lib| puts "#{prefix}- #{lib}" }
end
if output
  File.write(output, content)
else
  puts "#"
  puts "# #{"-" * 78}"
  puts ""
  puts content
end
