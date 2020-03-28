# frozen_string_literal: true

module Sample
  module Memoize
    def self.included(klass)
      memoizer = klass.const_set('ClearbitMemoizer', Module.new)

      klass.extend(ClassMethods)
      klass.prepend memoizer
    end

    module ClassMethods
      def memoize(method_name)
        memoizer = const_get('ClearbitMemoizer')
        memoizer.class_eval do
          define_method(method_name) do |*args, &block|
            @_memos ||= {}
            return @_memos[method_name] if @_memos.key?(method_name)

            @_memos[method_name] = super(*args, &block)
          end
        end
      end
    end
  end
end
