require 'pathname'
require 'set'
require 'thread_safe'
require 'tiki/torch/version'
require 'tiki/torch/core_ext'

module Tiki
  module Torch

    extend self

    def root
      ::Pathname.new File.expand_path('../../', __FILE__)
    end

    def processes
      @processes ||= Set.new
    end

    def shutdown
      processes.each do |x|
        logger.debug " shutting down (#{x.class.name}) #{x} ".center(90, '=')
        send(x).shutdown
      end
      final_time = Time.now + 10
      cnt = 0
      until all_stopped? || Time.now >= final_time
        cnt += 1
        logger.debug "[#{cnt}] waiting for all to stop ..."
        sleep 0.25
      end
      logger.debug 'all shut down ...'
    end

    private

    def all_stopped?
      stopped_responses.all? { |_, result| result == true }
    end

    def stopped_responses
      processes.map do |x|
        res = send(x).stopped?
        logger.debug 'stopped_responses : %-15.15s : stopped? : %s' % [x, res]
        [x, res]
      end
    end

    at_exit { shutdown }

  end
end

require 'tiki/torch/utils'
require 'tiki/torch/logging'
require 'tiki/torch/config'

require 'tiki/torch/transcoder'
require 'tiki/torch/transcoders/json'

require 'tiki/torch/stats'
require 'tiki/torch/consumer_poller'
require 'tiki/torch/consumers/settings'
require 'tiki/torch/consumers/hooks'
require 'tiki/torch/consumers/activerecord'
require 'tiki/torch/consumers/back_off'
require 'tiki/torch/consumers/publisher'
require 'tiki/torch/consumers/flow'
require 'tiki/torch/consumers/monitoring'
require 'tiki/torch/consumer'
require 'tiki/torch/event'
require 'tiki/torch/thread_pool'
require 'tiki/torch/consumer_broker'
require 'tiki/torch/node'

require 'tiki/torch/publisher'
