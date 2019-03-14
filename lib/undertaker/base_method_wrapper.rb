module Undertaker
  class BaseMethodWrapper

    attr_reader :klass

    def initialize(klass)
      @klass = klass
    end

    class << self
      def track_method(klass, method_name)
        Undertaker.config.backend.delete(record_key(klass.name), method_name)
      end

      def unwrap_method(klass, original_method)
        raise NotImplementedError
      end
    end

    def wrap_methods!
      potentially_unused_methods.each do |method_name|
        wrap_method(get_method(method_name))
      end
    end

    def refresh_cache
      Undertaker.config.backend.add(self.class.record_key(klass.name), default_methods)
    end

    private

    def default_methods
      raise NotImplementedError
    end

    def get_method(method_name)
      raise NotImplementedError
    end

    def wrap_method(original_method)
      raise NotImplementedError
    end

    def owned_method?(method_name)
      raise NotImplementedError
    end

    # Due to caching, new methods won't show up automatically in this call
    def potentially_unused_methods
      stored_methods = Undertaker.config.backend.get(self.class.record_key(klass.name))

      stored_methods & default_methods.map(&:to_s)
    end

  end
end
