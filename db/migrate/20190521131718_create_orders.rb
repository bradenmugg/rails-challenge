class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.belongs_to  :customer, index: true
      t.string :status, default: 'pending'
      t.integer :total_cost
      t.timestamp :created_at
    end
  end
end
