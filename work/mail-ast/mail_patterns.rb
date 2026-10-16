require "mail"

module Mail
  class Message
    FIELD_KEYS = Field::KNOWN_FIELDS.map { |name| name.tr("-", "_").to_sym }.freeze

    MESSAGE_KEYS = %i[
      body parts attachments multipart charset mime_type text_part html_part
    ].freeze

    DECONSTRUCT_KEYS = (FIELD_KEYS + MESSAGE_KEYS).freeze

    def deconstruct_keys(requested)
      (requested || DECONSTRUCT_KEYS).each_with_object({}) do |key, values|
        next unless DECONSTRUCT_KEYS.include?(key)

        values[key] = read_key(key)
      end
    end

    def deconstruct
      parts
    end

    private

    def read_key(key)
      case key
      when :multipart then multipart?
      when :body then multipart? ? nil : body.decoded
      else
        return public_send(key) if respond_to?(key)

        header[key.to_s.tr("_", "-")]&.value
      end
    rescue StandardError
      nil
    end
  end

  class Field
    def deconstruct_keys(_requested)
      { name: name, value: value }
    end
  end

  class Address
    def deconstruct_keys(_requested)
      { address: address, display_name: display_name, local: local, domain: domain }
    end
  end

  class Part
    def deconstruct_keys(requested)
      super.merge(
        filename: filename,
        attachment: attachment?,
        content_type: content_type,
      )
    end
  end
end
