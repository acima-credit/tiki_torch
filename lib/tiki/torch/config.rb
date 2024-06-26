module Tiki
  module Torch
    class Config

      include Virtus.model
      include Logging

      EVENT_SLEEP_TIMES = { idle: 60, busy: 60, received: 15, empty: 120, exception: 15, poll: 5, max_wait: 5 * 60 }

      class SerializationStrategies
        PREFIX = "prefix"
        MESSAGE_ATTRIBUTES = "message_attributes"
      end

      YAML_CODES = %w(yaml application/yaml application/x-yaml)
      JSON_CODES = %w(json application/json)

      attribute :access_key_id, String, default: lambda { |_, _| ENV['AWS_ACCESS_KEY_ID'] }
      attribute :secret_access_key, String, default: lambda { |_, _| ENV['AWS_SECRET_ACCESS_KEY'] }
      attribute :region, String, default: lambda { |_, _| ENV['AWS_REGION'] }
      attribute :sqs_endpoint, String

      attribute :prefix, String, default: 'tiki_torch'
      attribute :channel, String, default: 'events'

      attribute :default_delay, Integer, default: 0 # DelaySeconds
      attribute :max_size, Integer, default: 262144 # MaximumMessageSize
      attribute :retention_period, Integer, default: 345600 # MessageRetentionPeriod
      attribute :policy, String, default: nil # Policy
      attribute :receive_delay, Integer, default: 0 # ReceiveMessageWaitTimeSeconds
      attribute :visibility_timeout, Integer, default: 60 # VisibilityTimeout

      attribute :use_dlq, Boolean, default: false
      attribute :dlq_postfix, String, default: 'dlq'
      attribute :max_attempts, Integer, default: 10

      attribute :event_pool_size, Integer, default: lambda { |_, _| Concurrent.processor_count }
      attribute :transcoder_code, String, default: 'yaml'
      attribute :permitted_classes_for_YAML, Array, default: lambda { |_, _| [Symbol, Time, Date, DateTime, BigDecimal] }
      attribute :events_sleep_times, Hash, default: EVENT_SLEEP_TIMES
      attribute :serialization_strategy, String, default: SerializationStrategies::PREFIX

      attribute :valid_formats, Array, default: YAML_CODES.concat(JSON_CODES)
      # Can be anything that responds to `call`. Defaults to noop.
      # Virtus automatically calls anything that responds to `call`, so we have to wrap the
      # handler in a lambda.
      attribute :publishing_error_handler, Object, default: lambda { |_, _| Proc.new { |_, _, _| } }
      attribute :publishing_retry_handler, Object, default: lambda { |_, _| Proc.new { |_, _| } }

      attribute :retry_interval_secs, Integer
      attribute :retry_timeout_secs, Integer
      attribute :retry_count, Integer

      attribute :serial_qty, Integer, default: lambda { |_, _| ENV.fetch 'TIKI_SERIAL_POLLER_QTY', '10' }
      attribute :serial_timeout, Integer, default: lambda { |_, _| ENV.fetch 'TIKI_SERIAL_POLLER_TIMEOUT', '1' }
      attribute :serial_visibility, Integer, default: lambda { |_, _| ENV.fetch 'TIKI_SERIAL_POLLER_VISIBILITY', '60' }
      attribute :serial_wait_secs, Float, default: lambda { |_, _| ENV.fetch 'TIKI_SERIAL_POLLER_WAIT_SECS', '1.5' }

      def default_message_properties
        @default_message_properties ||= {}
      end

      def to_s
        %{#<T:T:Config access_key_id=#{access_key_id.inspect} region=#{region.inspect}>}
      end

      alias :inspect :to_s

    end

    def config
      @config ||= Config.new
    end

    def configure
      yield config
    end

    def aws_options
      {
        access_key_id:     config.access_key_id,
        secret_access_key: config.secret_access_key,
        region:            config.region,
      }
    end

    def setup_aws(options = {})
      ::Aws.config = aws_options.merge options
    end

    config

  end
end
