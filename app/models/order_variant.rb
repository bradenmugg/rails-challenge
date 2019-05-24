class OrderVariant < ApplicationRecord
  belongs_to :order
  belongs_to :variant

  validates :variant, :order, :quantity, presence: true

  def as_json(options = {})
    super.merge(variant.attributes.except('id', 'weight', 'product_id'))
  end
end
