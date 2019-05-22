class OrderVariant < ApplicationRecord
  belongs_to :order
  belongs_to :variant

  validates_associated :variant
end
