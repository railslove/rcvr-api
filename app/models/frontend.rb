class Frontend < ApplicationRecord
  has_many :owners
  belongs_to :whitelabel, optional: true
end
