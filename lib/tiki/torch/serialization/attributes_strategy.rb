module Tiki
  module Torch
    module Serialization
      class AttributesStrategy
        include Logging

        class << self

          # PUBLISHING EVENTS ARE SERIALIZED
          def serialize(event)
            attributes = build_message_attributes(event.properties, event.code)
            payload = Torch::Transcoder.encode(event.payload, event.code)
            { message_body: payload }.merge(attributes)
          end

          # CONSUMER EVENTS ARE DESERIALIZED
          def deserialize(event)
            attrs = get_message_attributes(event.message_attributes)
            code = attrs[:content_type]
            payload = Torch::Transcoder.decode(event.body, code)
            [payload, attrs]
          end

          private

          def build_message_attributes(attributes, code)
            attributes = Torch.config.default_message_properties.dup.
              merge("messageId" => SecureRandom.hex, "publishedAt" => Time.now.to_s).
              merge(attributes)

            usable_attrs = attributes.dup.reject{|k| k.to_sym == :transcoder_code}
            pairs = { "Content-Type" => code }.merge(usable_attrs)

            msg_attrs = pairs.each_with_object({}) do |(k,v), hsh|
              key = k.to_s
              value = v.to_s
              hsh[key] = { string_value: v, data_type: "String" }
            end
            { message_attributes: msg_attrs }
          end

          def get_message_attributes(attributes)
            attributes.each_with_object({}) do |(k,v), hsh|
              if v.data_type.downcase != "string"
                info("Unsupported attribute type: #{v.data_type}")
                next
              end
              key = k.underscore.to_sym
              hsh[key] = v.string_value
            end
          end

        end
      end
    end
  end
end
