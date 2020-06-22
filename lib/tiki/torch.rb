require 'pathname'
require 'set'
require 'thread'
require 'socket'
require 'lifeguard'
require 'timeout'
require 'concurrent'
require 'concurrent/utility/processor_counter'
require 'concurrent/thread_safe/util/adder'
require 'concurrent/hash'
require 'concurrent/timer_task'
require 'concurrent-edge'
require 'virtus'
require 'multi_json'
require 'forwardable'
require 'colorize'
require 'yaml'
require 'logger'
require 'aws-sdk-sqs'
require 'zlib'

require 'tiki/torch/version'
require 'tiki/torch/core_ext'

module Tiki
  module Torch

    extend self

    def root
      ::Pathname.new File.expand_path('../../', __FILE__)
    end

  end
end

require 'tiki/torch/utils'
require 'tiki/torch/logging'
require 'tiki/torch/config'
require 'tiki/torch/stats'
require 'tiki/torch/thread_pool'

require 'tiki/torch/transcoder'
require 'tiki/torch/transcoders/json'
require 'tiki/torch/transcoders/yaml'

require 'tiki/torch/aws/queue_attributes'
require 'tiki/torch/aws/queue'
require 'tiki/torch/aws/message'
require 'tiki/torch/aws/client'

require 'tiki/torch/serialization/attributes_strategy'
require 'tiki/torch/serialization/prefix_strategy'

require 'tiki/torch/consumers/publishing'
require 'tiki/torch/consumer_registry'
require 'tiki/torch/consumer_poller'
require 'tiki/torch/consumers/settings'
require 'tiki/torch/consumers/hooks'
require 'tiki/torch/consumers/event'
require 'tiki/torch/consumer'

require 'tiki/torch/consumer_builder'
require 'tiki/torch/consumer_broker'
require 'tiki/torch/manager'

require 'tiki/torch/publishing/message'
require 'tiki/torch/publishing/publisher'
require 'tiki/torch/publishing/retries'

require 'tiki/torch/serial_manager'
require 'tiki/torch/serial_poller'
