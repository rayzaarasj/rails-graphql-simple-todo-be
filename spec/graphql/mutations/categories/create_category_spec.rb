# frozen_string_literal: true

require 'rails_helper'

module Mutations
  module Categories
    RSpec.describe CreateCategory, type: :request do
      describe '.resolve' do
        subject do
          post '/graphql', params: { query: query }
          response
        end

        it 'creates a category' do
          expect { subject }.to change { Category.count }.by(1)
        end

        it 'returns a category' do
          is_expected.to have_http_status :ok
          json = JSON.parse(response.body)
          data = json['data']['createCategory']

          expect(data).to include(
            'category' => {
              'id' => be_present,
              'category' => 'test_category'
            }
          )
        end
      end

      def query
        <<~GQL
          mutation{
            createCategory(input: {
              category: "test_category",
            }) {
              category {
                id
                category
              }
            }
          }
        GQL
      end
    end
  end
end
