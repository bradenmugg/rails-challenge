# frozen_string_literal: true

class OrdersController < ApplicationController
  def create
    @order = Order.new(order_params)
    @order.save
  end

  private

  def order_params
    params.require([:customer_id, order_variants_attributes: %i[id quantity]])
  end

  def required_params
    %i[customer_id order_variants_attributes]
  end
end
