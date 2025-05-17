# frozen_string_literal: true
require "English"
require "fileutils"
require_relative "expand"

def run(args)
  expand_params = {
    mode: :blacklist,
    includes: %w[],
    excludes: %w[],
    service: :atcoder
  }

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
      opts.on(
        "-p",
        "--preset=SERVICE",
        "Specify SERVICE as preset. (atcoder or vanilla, default is atcoder)"
      ) { |service| expand_params[:preset] = service.to_sym }

      opts.on("-i", "--include=LIB", "Specify LIB as include path.") do |lib|
        expand_params[:mode] = :whitelist
        expand_params[:includes] << lib
      end
      opts.on("-e", "--exclude=LIB", "Specify LIB as exclude path.") do |lib|
        expand_params[:excludes] << lib
      end
    end

  subparser.parse!(args)

  if args.empty?
    puts subparser.help
    exit
  end

  file = args[0]
  output = args[1]

  unless File.exist?(file)
    warn "File not found: #{file}"
    exit(1)
  end

  content = +File.read(file)
  expand(content, file, expand_params) => {
    kept_libraries:,
    expanded_libraries:,
    errored_libraries:,
    removed_libraries:,
    content:
  }

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
    dir = File.dirname(output)
    FileUtils.mkdir_p(dir)
    File.write(output, content)
  else
    puts "#"
    puts "# #{"-" * 78}"
    puts ""
    puts content
  end
end
