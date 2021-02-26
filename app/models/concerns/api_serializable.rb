module ApiSerializable
  extend ActiveSupport::Concern

  included do
    def as_json(options)
      attributes = self.class.const_get(:EXPOSED_ATTRIBUTES)

      super options.merge(methods: attributes, only: attributes)
    end
  end
end
