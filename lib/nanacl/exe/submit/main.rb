# frozen_string_literal: true
require_relative "../expand/expand"

def run(args)
  command = "oj s %"
  expand_params = {
    mode: :blacklist,
    includes: %w[],
    excludes: %w[],
    service: :atcoder
  }

  subparser =
    OptionParser.new do |opts|
      opts.banner = "Usage: nanacl submit [options] FILE [extra options]"

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
      ) { |service| expand_params[:service] = service.to_sym }

      opts.on("-i", "--include=LIB", "Specify LIB as include path.") do |lib|
        expand_params[:mode] = :whitelist
        expand_params[:includes] << lib
      end
      opts.on("-e", "--exclude=LIB", "Specify LIB as exclude path.") do |lib|
        expand_params[:excludes] << lib
      end

      opts.on(
        "-c",
        "--command=COMMAND",
        "Specify COMMAND as submission command. " \
          "(% for the expanded file path, or omit to get content from stdin)"
      ) { |cmd| command = cmd }
    end

  subparser.parse!(args)

  if args.empty?
    puts subparser.help
    exit
  end

  file = args[0]

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
  puts "Kept libraries:"
  if kept_libraries.empty?
    puts "  (none)"
  else
    kept_libraries.each { |lib| puts "- #{lib}" }
  end
  puts "Expanded libraries:"
  if expanded_libraries.empty?
    puts "  (none)"
  else
    expanded_libraries.each { |lib| puts "- #{lib}" }
  end
  puts "Errored libraries:"
  if errored_libraries.empty?
    puts "  (none)"
  else
    errored_libraries.each { |lib| puts "- #{lib}" }
  end
  puts "Removed libraries:"
  if removed_libraries.empty?
    puts "  (none)"
  else
    removed_libraries.each { |lib| puts "- #{lib}" }
  end
  file =
    if expanded_libraries.empty? && errored_libraries.empty? &&
         removed_libraries.empty?
      puts "No libraries were expanded."
      file
    else
      File.write("./expanded.rb", content)
      "./expanded.rb"
    end

  if command.include?("%")
    command = command.gsub("%", file)
    puts "Running: #{command}"
    system(command)
  else
    puts "Running with stdin: #{command}"
    system(command, input: file)
  end
end
