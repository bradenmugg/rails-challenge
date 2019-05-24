class Order < ApplicationRecord
  has_many :order_variants, inverse_of: :order
  has_many :variants, through: :order_variants
  belongs_to :customer
  accepts_nested_attributes_for :order_variants
  validates_associated :order_variants

  def as_json(options = {})
    super.merge(variants: order_variants.as_json(except: %w[id order_id]))
  end
end
