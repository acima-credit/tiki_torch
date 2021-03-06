module Tiki
  module Torch
    class Stats

      class Counter

        def initialize(name, initial_value = 0)
          @name  = name
          @value = Concurrent::ThreadSafe::Util::Adder.new.tap do |c|
            c.add(initial_value) unless initial_value == 0
          end
        end

        def increment(size = 1)
          @value.add size
          value
        end

        def value
          @value.sum
        end

        alias :to_i :value

        def to_s
          %{#<#{self.class.name} value=#{value}>}
        end

        alias :inspect :to_s

      end

      attr_reader :counters

      def initialize(*names)
        @counters = Concurrent::Hash.new
        names.map { |x| get_or_set_counter x }
      end

      def get_or_set_counter(name, initial_value = 0)
        safe_name = name.to_s.underscore.to_sym
        found     = @counters[safe_name]
        return found if found

        @counters[safe_name] = Counter.new name, initial_value
      end

      alias :counter :get_or_set_counter
      alias :[] :get_or_set_counter

      def increment(name)
        counter(name).increment
      end

      def to_hash
        @counters.keys.each_with_object({}) { |k, h| h[k] = @counters[k].value }
      end

      def to_s
        %{#<#{self.class.name} #{to_hash.map { |k, v| "#{k}=#{v}" }.join(' ')}>}
      end

      alias :inspect :to_s

    end
  end
end