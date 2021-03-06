# frozen_string_literal: true

class TestBroker < Tiki::Torch::ConsumerBroker
  def event_pool=(value)
    @event_pool = value
  end
end

class TestClient < Tiki::Torch::AwsClient
  def known_queues
    { 'test_queue-events' => TestQueue }
  end
end

class TestQueue
  class << self
    def push(val)
      @collection ||= []
      @collection.push(val)
    end

    def pop
      @collection ||= []
      @collection.pop
    end

    def messages
      @collection
    end

    def clear
      @collection = []
    end

    alias send_message push
    alias receive_messages pop
  end
end

class FakeEventPool
  def self.async
    yield
  end
end

class TestConsumer < Tiki::Torch::Consumer
  def process
    TestQueue.push(payload)
  end
end
