module Tiki
  module Torch
    class YamlTranscoder < Transcoder
      class << self
        def codes
          Torch::Config::YAML_CODES
        end

        def encode(body = {})
          body.to_yaml
        end

        def decode(str)
          if RUBY_VERSION[0].to_i < 3
            YAML.load(str)
          else
            # psych 4.0 alias supp
            begin
              YAML.load(str, aliases: true, permitted_classes: Torch.config.permitted_classes_for_YAML)
            rescue ArgumentError
              YAML.load(str, permitted_classes: Torch.config.permitted_classes_for_YAML)
            end
          end
        end
      end
    end
  end
end
