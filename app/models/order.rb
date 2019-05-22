class Order < ApplicationRecord
  has_and_belongs_to_many :variants, join_table: :order_variants
end
