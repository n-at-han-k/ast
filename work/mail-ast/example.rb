require_relative "mail_patterns"

FIXTURES = Dir.glob(File.expand_path("fixtures/*.eml", __dir__)).sort

def classify(message)
  case message
  in { multipart: true, subject: /\A\[(?<project>[^\]]+)\] build (?<build>\d+) failed/, from: [sender, *], parts: }
    build = Regexp.last_match
    [:build_failure, "#{build[:project]} build #{build[:build]} from #{sender}, #{parts.size} parts"]

  in { multipart: true, subject:, parts: }
    [:multipart, "#{subject.inspect} in #{parts.size} parts"]

  in { multipart: false, subject:, body: }
    [:plain, "#{subject.inspect}, #{body.lines.size} lines"]
  end
end

def thread_position(message)
  case message
  in { in_reply_to: String => parent, references: [_, _, *] => chain }
    "reply to #{parent}, #{chain.size} deep, rooted at #{chain.first}"
  in { in_reply_to: String => parent, references: String => root }
    "reply to #{parent}, single reference #{root}"
  in { in_reply_to: String => parent }
    "reply to #{parent}"
  in { message_id: String => id }
    "thread root #{id}"
  end
end

def describe_part(part)
  case part
  in { attachment: true, filename:, content_type: }
    kind = content_type.split(";").first
    "attachment #{filename} (#{kind})"
  in { content_type: /\Atext\/html/ }
    "html alternative"
  in { content_type: /\Atext\/plain/, body: }
    "plain text, #{body.lines.size} lines"
  else
    "part #{part.content_type}"
  end
end

def recipients(message)
  case message
  in { to: [_, _, *] => many, cc: [_, *] => copied }
    "#{many.size} recipients, copied to #{copied.join(", ")}"
  in { to: [_, _, *] => many }
    "#{many.size} recipients, no copies"
  in { to: [only] }
    "one recipient, #{only}"
  in { to: nil }
    "no recipients"
  end
end

FIXTURES.each do |fixture|
  message = Mail.read(fixture)
  path = fixture.sub("#{Dir.pwd}/", "")
  kind, detail = classify(message)

  puts path
  puts "  classify:   #{kind} - #{detail}"
  puts "  thread:     #{thread_position(message)}"
  puts "  recipients: #{recipients(message)}"

  message.parts.each { |part| puts "  part:       #{describe_part(part)}" }

  message[:from].addrs.each do |address|
    shown = case address
            in { display_name: String => name, local:, domain: }
              "#{name} at #{local}@#{domain}"
            in { address: }
              address
            end
    puts "  from:       #{shown}"
  end

  puts
end

puts "fields, through Mail::Field:"
Mail.read(FIXTURES.first).header.fields.first(4).each do |field|
  shown = case field
          in { name: "Received", value: }
            "Received, #{value.length} chars"
          in { name:, value: }
            "#{name}: #{value}"
          end
  puts "  #{shown}"
end

puts
puts "keys available on a message: #{Mail::Message::DECONSTRUCT_KEYS.size}"
