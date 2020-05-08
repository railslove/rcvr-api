class Ticket < ApplicationRecord
  belongs_to :company

  validates :id, absence: true, on: :update, if: :id_changed? # Can never update id
end
