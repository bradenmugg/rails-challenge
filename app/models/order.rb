class Order < ApplicationRecord
  has_and_belongs_to_many :variants, join_table: :order_variants
  has_many :order_variants
  accepts_nested_attributes_for :order_variants
end
