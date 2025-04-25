# frozen_string_literal: true
require "English"
require "json"
require_relative "libraries"
require "securerandom"

def expand(content, _source_path, expand_params)
  internal_info_header = "nanacl_internal_info"
  main_placeholder = "main"

  header = "main = -> do # ".ljust(80, "=")
  footer = "end # ".ljust(80, "-")
  content = <<~RUBY
  #{header}
  #{content}
  #{footer}
  RUBY
  kept_libraries = Set.new
  expanded_libraries = Set.new
  errored_libraries = Set.new
  removed_libraries = Set.new
  nonce = 0
  marker = "_nanacl_#{SecureRandom.hex(4)}_"

  excludes = STD_LIBRARIES + expand_params[:excludes]
  excludes += ATCODER_LIBRARIES if expand_params[:preset] == :atcoder
  loop do
    libraries = []
    content.gsub!(
      /^require(?<relative>_relative)? (?<quote>"|')(?<module_path>.+?)\k<quote>/
    ) do |original|
      module_path = $LAST_MATCH_INFO.named_captures["module_path"]
      is_relative = !$LAST_MATCH_INFO.named_captures["relative"].nil?
      internal_info =
        $LAST_MATCH_INFO
          .pre_match
          .lines
          .filter_map do |line|
            line.match(/# #{internal_info_header} (?<info>.+)/) do |m|
              JSON.parse(m[:info], symbolize_names: true)
            end
          end
          .last || {}
      is_relative = true if module_path.start_with?(".")
      package_path = module_path.split("/").first
      should_keep =
        if expand_params[:mode] == :whitelist
          expand_params[:includes].include?(package_path)
        else
          excludes.include?(module_path) &&
            !expand_params[:includes].include?(package_path)
        end
      if should_keep
        kept_libraries << module_path
      else
        expanded_libraries << module_path
        if is_relative
          file_path = internal_info[:path] || file
          source = internal_info[:source] || main_placeholder
          file_dir = File.dirname(file_path)
          module_path += ".rb" unless module_path.end_with?(".rb")
          path = File.join(file_dir, module_path)
          if File.exist?(path)
            library = File.read(path)
            nonce += 1
            header = "# == relative: #{module_path} from #{source} "
            libraries << <<~LIBRARY
            #{header.ljust(80, "-")}
            #{library}
            LIBRARY

            next("# #{original} # (expanded: #{marker}#{module_path}#{marker})")
          else
            unless errored_libraries.include?(module_path)
              warn "Failed to expand #{module_path}: not found"
            end
            errored_libraries << module_path
          end
        else
          type, path =
            $LOAD_PATH.resolve_feature_path(module_path) || [nil, nil]
          if type == :rb && path
            library = File.read(path)
            nonce += 1
            source = internal_info[:source] || main_placeholder
            header = "# == #{module_path} from #{source} "
            new_internal_info = JSON.generate({ path:, source: module_path })
            libraries << <<~LIBRARY
            #{header.ljust(80, "-")}
            # #{internal_info_header} #{new_internal_info}
            #{library}
            LIBRARY

            next("# #{original} # (expanded: #{marker}#{module_path}#{marker})")
          else
            unless errored_libraries.include?(module_path)
              warn "Failed to expand #{module_path}: not found"
            end
            errored_libraries << module_path
          end
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
    dependencies_line =
      content.lines.find_index { |line| line.include?("# === dependencies ") }
    content =
      content.lines[0..dependencies_line].join + libraries.join("\n") +
        content.lines[(dependencies_line + 1)..].join
  end
  # content.insert(0, "# This file is expanded by nanacl.\n")
  # content.insert(0, "# frozen_string_literal: true\n")
  content.insert(0, <<~RUBY)
  # frozen_string_literal: true
  # This file is expanded by nanacl.

  RUBY
  content += "\n"
  content += "# ".ljust(80, "=")
  content += "\n"
  content += "\n"
  content += "main.call\n"
  content.gsub!(/# #{internal_info_header} .+\n/, "")
  content.gsub!(
    /#{Regexp.escape(marker)}(?<module_path>.+?)#{Regexp.escape(marker)}/
  ) do |original|
    module_path = $LAST_MATCH_INFO.named_captures["module_path"]
    line_index =
      content.lines.find_index do |line|
        line.start_with?(/# == (?:relative: )?#{Regexp.escape(module_path)} /)
      end
    if line_index.nil?
      warn "Failed to replace #{module_path}: not found"
      next original
    end

    line_number = line_index + 1
    "L#{line_number}"
  end

  {
    content:,
    kept_libraries:,
    expanded_libraries:,
    errored_libraries:,
    removed_libraries:
  }
end
