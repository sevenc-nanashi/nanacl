require_relative "../expand/expand"

def run(args)
  expand_params = { mode: :blacklist, includes: %w[], excludes: %w[] }

  subparser =
    OptionParser.new do |opts|
      opts.banner = "Usage: nanacl submit [options] FILE [oj options]"

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
  if kept_libraries.empty? && expanded_libraries.empty? && errored_libraries.empty? && removed_libraries.empty?
    puts "No libraries were expanded."

    command = "oj s #{file} #{args[1..-1].join(" ")}"
  else
    File.write("./expanded.rb", result)

    command = "oj s ./expanded.rb #{args[1..-1].join(" ")}"
  end

  puts "Running: #{command}"
  system(command)
end
