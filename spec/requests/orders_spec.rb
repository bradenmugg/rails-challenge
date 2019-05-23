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
  end
end
