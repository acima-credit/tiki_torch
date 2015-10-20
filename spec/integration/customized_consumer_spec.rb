describe CustomizedConsumer do

  context 'config', focus: true do
    it('topic             ') { expect(consumer.topic).to eq 'test.customized' }
    it('topic_prefix      ') { expect(consumer.topic_prefix).to eq config.topic_prefix }
    it('channel           ') { expect(consumer.channel).to eq config.channel }
    it('dlq_postfix       ') { expect(consumer.dlq_postfix).to eq config.dlq_postfix }
    it('visibility_timeout') { expect(consumer.visibility_timeout).to eq config.visibility_timeout }
    it('message_retention ') { expect(consumer.message_retention_period).to eq config.message_retention_period }
    it('max_in_flight     ') { expect(consumer.max_in_flight).to eq config.max_in_flight }
    it('max_attempts      ') { expect(consumer.max_attempts).to eq config.max_attempts }
    it('event_pool_size   ') { expect(consumer.event_pool_size).to eq config.event_pool_size }
    it('transcoder_code   ') { expect(consumer.transcoder_code).to eq config.transcoder_code }
    it('sleep_times       ') { expect(consumer.events_sleep_times).to eq config.events_sleep_times }
    it('queue_name        ') { expect(consumer.queue_name).to eq "#{config.topic_prefix}-test.customized-events" }
  end
  context 'processing', integration: true, polling: true do
    it 'receives successful message and overrides successful hooks' do
      time_it 'test #1' do
        time_it('publish message', '-') { consumer.publish status: 'ok' }
        $lines.wait_for_size 3, 10

        expect($lines.all).to eq ['started', 'succeeded with true', 'end']
      end
    end
    it 'receives meh message and overrides success hook' do
      time_it 'test #2' do
        time_it('publish message', '-') { consumer.publish status: 'meh' }
        $lines.wait_for_size 3, 10

        expect($lines.all).to eq ['started', 'succeeded with false', 'end']
      end
    end
    it 'receives failed message and overrides failure hook' do
      time_it 'test #3' do
        time_it('publish message', '-') { consumer.publish status: 'something else' }
        $lines.wait_for_size 3, 10

        expect($lines.all).to eq ['started', 'failed with RuntimeError : Unknown status [something else]', 'end']
      end
    end
  end

end