module ApiSerializable
  extend ActiveSupport::Concern

  included do
    def attributes
      self.class.const_get(:EXPOSED_ATTRIBUTES).map do |attr|
        [attr, public_send(attr)]
      end.to_h
    end
  end
end
