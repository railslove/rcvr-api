module ApiSerializable
  extend ActiveSupport::Concern

  included do
    def as_json(options = nil)
      attributes = self.class.const_get(:EXPOSED_ATTRIBUTES)

      super ({ methods: attributes, only: attributes }).merge(options || {})
    end
  end
end
