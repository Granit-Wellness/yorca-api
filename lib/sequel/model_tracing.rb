# frozen_string_literal: true

module Sequel
  module Plugins
    module ModelTracing
      module MethodWrapping
        # Install a method named +method_name+ that will trace execution
        # with a metric name derived from +operation_name+ (or +method_name+ if +operation_name+
        # isn't specified).
        def wrap_sequel_method(method_name, operation_name = method_name)
          define_method(method_name) do |*args, &block|
            klass = is_a?(Class) ? self : self.class
            name = respond_to?(:model) ? model : klass

            ::Sequel::Instrumentation.trace_query("#{name}##{operation_name}", {}) do
              super(*args, &block)
            end
          end
        end
      end

      # Methods to be added to Sequel::Model instances.
      module InstanceMethods
        extend Sequel::Plugins::ModelTracing::MethodWrapping

        wrap_sequel_method :delete
        wrap_sequel_method :destroy
        wrap_sequel_method :update
        wrap_sequel_method :update_fields
        wrap_sequel_method :save
      end

      # Methods to be added to Sequel::Model datasets.
      module DatasetMethods
        extend Sequel::Plugins::ModelTracing::MethodWrapping

        wrap_sequel_method :delete
        wrap_sequel_method :destroy
        wrap_sequel_method :update
        wrap_sequel_method :[], 'get'
        wrap_sequel_method :all
        wrap_sequel_method :first
      end

      # Methods to be added to Sequel::Model classes.
      module ClassMethods
        extend Sequel::Plugins::ModelTracing::MethodWrapping

        wrap_sequel_method :create
      end
    end
  end
end
