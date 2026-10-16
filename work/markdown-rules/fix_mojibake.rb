BYTE_FOR = (0x00..0xFF).each_with_object({}) do |byte, map|
  decoded = begin
    byte.chr(Encoding::BINARY).force_encoding(Encoding::WINDOWS_1252).encode(Encoding::UTF_8)
  rescue Encoding::UndefinedConversionError
    byte.chr(Encoding::BINARY).force_encoding(Encoding::ISO_8859_1).encode(Encoding::UTF_8)
  end
  map[decoded.ord] = byte
end

path = ARGV.fetch(0)
raw = File.binread(path).force_encoding(Encoding::UTF_8)
abort "#{path}: not valid UTF-8" unless raw.valid_encoding?

unmapped = raw.each_char.reject { |ch| BYTE_FOR.key?(ch.ord) }.uniq
abort "#{path}: characters outside the cp1252 round-trip: #{unmapped.inspect}" unless unmapped.empty?

fixed = raw.each_char.map { |ch| BYTE_FOR.fetch(ch.ord) }.pack("C*").force_encoding(Encoding::UTF_8)
abort "#{path}: result is not valid UTF-8" unless fixed.valid_encoding?

if ARGV.include?("--write")
  File.binwrite(path, fixed)
  warn "#{path}: #{raw.bytesize} -> #{fixed.bytesize} bytes"
else
  print fixed
end
