# frozen_string_literal: true

require 'rails_helper'

module Queries
  module Categories
    RSpec.describe Categories, type: :request do
      describe '.resolve' do
        let!(:category) { create(:category) }

        subject do
          post '/graphql', params: { query: query(category_id: category.id) }
          response
        end

        it 'returns the correct category' do
          is_expected.to have_http_status :ok
          json = JSON.parse(response.body)
          data = json['data']['categoryById']

          expect(data).to include(
            {
              'id' => "#{category.id}",
              'category' => "#{category.category}"
            }
          )
        end
      end

      def query(category_id:)
        <<~GQL
          query {
            categoryById(id:#{category_id}) {
              id
              category
            }
          }
        GQL
      end
    end
  end
end
