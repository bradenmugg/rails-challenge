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

  def show
    @order = Order.find(params[:id])
    render json: { message: @order.as_json }, status: :ok
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
        variant = order_variant.variant
        variant.update_attributes!(
          stock_amount: variant.stock_amount - order_variant.quantity
        )
        @order.total_cost += variant.cost * order_variant.quantity
      end
      @order.save!
    end
  rescue ActiveRecord::RecordInvalid
    @order.errors.add(:Quantity, message: 'exceeds available stock')
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
