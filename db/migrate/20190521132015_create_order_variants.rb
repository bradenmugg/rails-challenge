class CreateOrderVariants < ActiveRecord::Migration[5.2]
  def change
    create_table :order_variants do |t|
      t.belongs_to  :order, index: true
      t.belongs_to  :variant, index: true
      t.integer :quantity
    end
  end
end
