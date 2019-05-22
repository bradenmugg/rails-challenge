class Variant < ApplicationRecord
  belongs_to :product
  has_and_belongs_to_many :orders, join_table: :order_variants
end
