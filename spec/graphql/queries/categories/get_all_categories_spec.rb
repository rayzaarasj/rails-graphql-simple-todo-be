# frozen_string_literal: true

require 'rails_helper'

module Queries
  module Categories
    RSpec.describe Categories, type: :request do
      describe '.resolve' do
        let!(:category_1) { create(:category) }
        let!(:category_2) { create(:category) }

        subject do
          post '/graphql', params: { query: query() }
          response
        end

        it 'returns all catergories' do
          is_expected.to have_http_status :ok
          json = JSON.parse(response.body)
          data = json['data']['categories']

          expect(data).to include(
            {
              'id' => "#{category_1.id}",
              'category' => "#{category_1.category}"
            },
            {
              'id' => "#{category_2.id}",
              'category' => "#{category_2.category}"
            }
          )
        end
      end

      def query
        <<~GQL
          query {
            categories {
              id
              category
            }
          }
        GQL
      end
    end
  end
end
