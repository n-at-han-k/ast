require "fileutils"

module ExtractGir
  DESTINATION = File.expand_path("gir", __dir__)
  WANTED = %w[Gtk-4.0 Adw-1].freeze
  MEGABYTE = 1_048_576.0

  Repository = Struct.new(:path, :namespace, :version, :includes, :packages, keyword_init: true) do
    def name = "#{namespace}-#{version}"
    def size = File.size(path)
    def store = path[%r{\A/nix/store/([^/]+)}, 1]
  end

  module_function

  def search_path
    ENV.fetch("GIR_PATH", "").split(":").reject(&:empty?)
  end

  def repositories
    search_path.flat_map { |directory| Dir.glob(File.join(directory, "*.gir")) }
               .uniq { |path| File.basename(path) }
               .map { |path| read_header(path) }
               .sort_by(&:name)
  end

  def read_header(path)
    namespace = nil
    version = nil
    includes = []
    packages = []

    in_namespace = false

    File.foreach(path) do |line|
      includes << "#{Regexp.last_match(1)}-#{Regexp.last_match(2)}" if line =~ /<include name="([^"]+)" version="([^"]+)"/
      packages << Regexp.last_match(1) if line =~ /<package name="([^"]+)"/

      in_namespace = true if line.include?("<namespace ")

      if in_namespace
        namespace ||= line[/\sname="([^"]+)"/, 1]
        version ||= line[/\sversion="([^"]+)"/, 1]
      end

      break if namespace && version && !includes.empty? && in_namespace
    end

    Repository.new(path:, namespace:, version:, includes:, packages:)
  end

  def closure(wanted = WANTED)
    available = repositories.to_h { |repository| [repository.name, repository] }
    resolved = {}
    missing = []
    queue = wanted.dup

    until queue.empty?
      name = queue.shift
      next if resolved.key?(name)

      repository = available[name]

      if repository.nil?
        missing << name
        next
      end

      resolved[name] = repository
      queue.concat(repository.includes)
    end

    [resolved, missing.uniq]
  end

  def extract!(resolved)
    FileUtils.mkdir_p(DESTINATION)

    resolved.each_value do |repository|
      target = File.join(DESTINATION, File.basename(repository.path))
      FileUtils.cp(repository.path, target)
      FileUtils.chmod("u+w", target)
    end

    DESTINATION
  end
end

if __FILE__ == $PROGRAM_NAME
  abort "GIR_PATH is empty: run inside nix develop .\#gtk" if ExtractGir.search_path.empty?

  entries = ExtractGir.search_path.size
  found = ExtractGir.repositories.size
  resolved, missing = ExtractGir.closure

  puts "GIR_PATH entries: #{entries}"
  puts "repositories found: #{found}"
  puts

  puts format("%-18s %10s  %s", "repository", "size", "includes")
  puts "-" * 96

  resolved.each_value do |repository|
    megabytes = repository.size / ExtractGir::MEGABYTE
    puts format("%-18s %9.1fM  %s", repository.name, megabytes, repository.includes.join(", "))
  end

  total = format("%.1f", resolved.each_value.sum(&:size) / ExtractGir::MEGABYTE)
  wanted = ExtractGir::WANTED.join(", ")

  puts
  puts "closure of #{wanted}: #{resolved.size} repositories, #{total}M"
  puts "missing from GIR_PATH: #{missing.inspect}"

  if ARGV.include?("--write")
    destination = ExtractGir.extract!(resolved).sub("#{Dir.pwd}/", "")
    puts "extracted to #{destination}"
  else
    puts "pass --write to copy them into work/gtk-ast/gir"
  end

  exit 1 unless missing.empty?
end
