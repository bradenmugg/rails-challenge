# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Orders endpoint', type: :request do
  describe 'create an order' do
    context 'when params are missing' do
      before { post '/orders', params: { order: nil } }

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end
    end

    context 'when customers or variants are invalid' do
      before { post '/orders', params: { order: { customer_id: 8, order_variants_attributes: [variant_id: 3, quantity: 4]} } }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end
