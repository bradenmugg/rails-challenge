class Variant < ApplicationRecord
  belongs_to :product
  has_many :order_variants, inverse_of: :variant
  has_many :orders, through: :order_variants
  validates :stock_amount, :numericality => { :greater_than_or_equal_to => 0 }
end
