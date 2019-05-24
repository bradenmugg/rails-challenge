# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Orders endpoint', type: :request do
  describe 'create an order' do
    context 'when params are missing' do
      it 'returns status code 400' do
        post '/orders', params: { order: nil }
        expect(response).to have_http_status(400)
      end
    end

    context 'when customers or variants are invalid' do
      it 'returns status code 404' do
        post '/orders',
             params: {
               order: {
                 customer_id: 8,
                 order_variants_attributes:
                   [variant_id: 3, quantity: 4]
               }
             }

        expect(response).to have_http_status(404)
      end
    end

    context 'when there is not enough stock for any of the variants' do
      let(:customer) { create :customer }
      let(:variant) { create :variant, stock_amount: 3 }

      it 'returns status code 422' do
        post '/orders',
             params: {
               order: {
                 customer_id: customer.id,
                 order_variants_attributes:
                   [variant_id: variant.id, quantity: 4]
               }
             }

        expect(response).to have_http_status(422)
      end
    end

    context 'when there is enough stock for all of the variants' do
      let(:customer) { create :customer }
      let(:variant) { create :variant, stock_amount: 4 }
      let(:variant_two) { create :variant, stock_amount: 4 }
      before do
        post '/orders',
             params: {
               order: {
                 customer_id: customer.id,
                 order_variants_attributes:
                   [{ variant_id: variant.id, quantity: 3 },
                    { variant_id: variant_two.id, quantity: 3 }]
               }
             }
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'sets total cost' do
        expect(
          Order.first.total_cost
        ).to eq((variant.cost * 3) + (variant_two.cost * 3))
      end
    end
  end

  describe 'get an order' do
    let(:customer) { create :customer }
    let(:variant) { create :variant, stock_amount: 4 }
    let(:variant_two) { create :variant, stock_amount: 4 }
    before do
      post '/orders',
           params: {
             order: {
               customer_id: customer.id,
               order_variants_attributes:
                 [{ variant_id: variant.id, quantity: 3 },
                  { variant_id: variant_two.id, quantity: 3 }]
             }
           }
    end

    let(:order) { Order.first }

    before { get "/orders/#{order.id}" }

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'displays all order fields' do
      expect(response.body).to include(
        *order.attributes.keys + %w[variant_id name cost quantity]
      )
    end
  end
end
