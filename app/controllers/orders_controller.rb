# frozen_string_literal: true

class OrdersController < ApplicationController
  def create
    @order = Order.new(order_params)
    unless @order.save
      render json: { message: @order.errors.messages }, status: :not_found
    end
  end

  private

  def order_params
    params.require(:order).permit(:customer_id, order_variants_attributes: %i[variant_id quantity])
  end
end
