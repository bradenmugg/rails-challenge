# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Orders endpoint', type: :request do
  describe 'create an order' do
    context 'when params are missing' do
      before { post '/orders', params: {} }

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end
    end
  end
end
