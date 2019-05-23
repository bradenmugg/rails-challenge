# frozen_string_literal: true

class OrdersController < ApplicationController
  def create
    @order = Order.new(order_params)
    if @order.valid? && process_order
      render json: { message: @order }, status: :ok
    else
      render_errors
    end
  end

  private

  def order_params
    params.require(:order).permit(
      :customer_id, order_variants_attributes: %i[variant_id quantity]
    )
  end

  def process_order
    @order.transaction do
      @order.order_variants.each do |order_variant|
        v = order_variant.variant
        v.update_attributes!(
          stock_amount: v.stock_amount - order_variant.quantity
        )
      end
      @order.save!
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  def render_errors
    if @order.errors.added?(:customer, :blank) ||
       @order.errors.added?('order_variants.variant', :blank)
      render json: { message: @order.errors.messages }, status: :not_found
    else
      render json: { message: @order.errors.messages },
             status: :unprocessable_entity
    end
  end
end
