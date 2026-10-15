require "rexml/document"

module GirSurvey
  GIR_DIR = File.expand_path("gir", __dir__)

  COUNTED = %w[class interface record enumeration bitfield callback function alias property glib:signal].freeze

  module_function

  def path_for(name)
    File.join(GIR_DIR, "#{name}.gir")
  end

  def document(name)
    REXML::Document.new(File.read(path_for(name)))
  end

  def counts(name)
    text = File.read(path_for(name))

    COUNTED.to_h do |element|
      [element, text.scan(Regexp.new("<" + Regexp.escape(element) + '\s')).size]
    end
  end

  def klass(name, class_name)
    document(name).elements["//class[@name='#{class_name}']"]
  end

  def properties_of(element)
    element.get_elements("property").map do |property|
      {
        name: property.attributes["name"],
        type: property.elements["type"]&.attributes&.dig("name"),
        writable: property.attributes["writable"] == "1",
        construct_only: property.attributes["construct-only"] == "1",
        since: property.attributes["version"],
      }
    end
  end

  def signals_of(element)
    element.get_elements("glib:signal").map { |signal| signal.attributes["name"] }
  end

  def enumeration(name, enum_name)
    document(name).elements["//enumeration[@name='#{enum_name}']"]
      &.get_elements("member")
      &.map { |member| member.attributes["name"] }
  end
end

if __FILE__ == $PROGRAM_NAME
  abort "run extract_gir.rb --write first" unless Dir.exist?(GirSurvey::GIR_DIR)

  %w[Gtk-4.0 Adw-1 GObject-2.0].each do |name|
    shown = GirSurvey.counts(name).map { |element, total| [element, total].join("=") }.join(" ")
    puts "#{name}: #{shown}"
  end

  puts
  element = GirSurvey.klass("Gtk-4.0", "Box")
  implements = element.get_elements("implements").map { |node| node.attributes["name"] }

  puts "Gtk.Box"
  puts "  parent:     #{element.attributes["parent"]}"
  puts "  implements: #{implements.join(", ")}"
  puts "  properties:"

  GirSurvey.properties_of(element).each do |property|
    flags = [property[:writable] ? "writable" : "readonly"]
    flags << "construct-only" if property[:construct_only]
    puts format("    %-18s %-22s %s", property[:name], property[:type], flags.join(", "))
  end

  puts "  signals: #{GirSurvey.signals_of(element).join(", ")}"

  puts
  puts "enumeration domains:"
  %w[Orientation Align Justification].each do |enum|
    members = GirSurvey.enumeration("Gtk-4.0", enum)
    puts "  Gtk.#{enum}: #{members.join(", ")}"
  end

  puts
  button = GirSurvey.klass("Gtk-4.0", "Button")
  puts "Gtk.Button"
  puts "  parent: #{button.attributes["parent"]}"

  GirSurvey.properties_of(button).each do |property|
    puts format("    %-18s %s", property[:name], property[:type])
  end
end
