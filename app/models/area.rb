class Area < ApplicationRecord
  include ApiSerializable

  belongs_to :company

  EXPOSED_ATTRIBUTES = %i[id name]
end
