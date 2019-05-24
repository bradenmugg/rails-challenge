class ChangeTotalCostDefaultOrders < ActiveRecord::Migration[5.2]
  def change
    change_column_default :orders, :total_cost, from: nil, to: 0
  end
end
