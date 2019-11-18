module DeadCodeDetector
  class Configuration

    attr_accessor :redis, :classes_to_monitor, :error_handler, :allowed, :cache_expiry, :ignore_paths, :max_seconds_to_enable

    STORAGE_BACKENDS = {
      memory: Storage::MemoryBackend,
      redis: Storage::RedisBackend,
    }

    def initialize
      @allowed = true
      @classes_to_monitor = []
      @cache_expiry = 60 * 60 * 24 * 14
      @max_seconds_to_enable = 1
    end

    def storage=(backend_type)
      @storage ||= STORAGE_BACKENDS.fetch(backend_type).new
    end

    def storage
      if @storage
        @storage
      else
        raise "#{self.class.name}#storage is not configured"
      end
    end

  end
end
