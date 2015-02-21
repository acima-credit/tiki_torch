# -*- encoding: utf-8 -*-

require 'colorize'
require 'yaml'

module Tiki
  module Torch
    module Logging

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods

        def colorized_logging?
          Torch.config.colorized
        end

        def logger
          Torch.logger
        end

        def debug_var(var_name, var, meth = :inspect)
          msg   = var.nil? ? 'NIL' : var.send(meth)
          msg   = msg[0..-2] if msg[-1, 1] == "\n"
          klass = var.is_a?(Class) ? var.name : var.class.name
          debug "#{var_name} : (#{klass}:#{var.object_id}) #{msg}"
        end

        def log(string, type = :debug, color = :blue)
          msg = "#{log_prefix} #{string}"
          logger.send type, colorized_logging? ? msg.send(color) : msg
        end

        def debug(string)
          log string, :debug, :white
        end

        def info(string)
          log string, :info, :blue
        end

        def warn(string)
          log string, :warn, :yellow
        end

        def error(string)
          log string, :error, :red
        end

        def log_prefix
          prefix      = name
          _, _, label = log_prefix_labels
          prefix      += ".#{label}" if label
          # prefix += ":#{lineno}" if lineno
          prefix.rjust(35, ' ')[-35,35] + ' | '
        end

        def log_prefix_labels
          caller.lazy.reject { |x| x.index(__FILE__) }.map { |x| x =~ /(.*):(.*):in `(.*)'/ ? [$1, $2, $3] : nil }.first
        end

      end

      def debug(string)
        self.class.debug string
      end

      def debug_var(name, var, meth = :inspect)
        self.class.debug_var name, var, meth
      end

      def info(string)
        self.class.info string
      end

      def warn(string)
        self.class.warn string
      end

      def error(string)
        self.class.error string
      end

    end
  end
end