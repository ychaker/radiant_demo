module Con
  module CacheClearing

    def self.included(base)
      base.extend AddActsAsCacheClearing
    end

    module AddActsAsCacheClearing
      def acts_as_cache_clearing
        class_eval do
          after_save do
            Radiant::Cache.clear
          end
        end
      end
    end
  end
end
