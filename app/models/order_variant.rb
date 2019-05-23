class OrderVariant < ApplicationRecord
  belongs_to :order
  belongs_to :variant

  validates :variant, :order, presence: true
end
