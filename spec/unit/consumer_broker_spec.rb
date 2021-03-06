# frozen_string_literal: true

module Tiki
  module Torch
    describe ConsumerBroker, :fast do
      let(:consumer) { SimpleConsumer }
      let(:manager) do
        instance_double 'Tiki::Torch::Manager',
                        to_s: '#<T:T:Manager brokers=2 config=#<T:T:Config access_key_id="fake_access_key" ' \
                              'region="fake_region"> client=#<T:T:AwsClient>>'
      end
      subject { described_class.new consumer, manager }
      context 'basic' do
        it('to_s') do
          expect(subject.to_s).to eq '#<T:T:ConsumerBroker consumer=SimpleConsumer manager=#<T:T:Manager ' \
                                     'brokers=2 config=#<T:T:Config access_key_id="fake_access_key" region="fake_region"> client=#<T:T:AwsClient>>>'
        end
      end
    end
  end
end
