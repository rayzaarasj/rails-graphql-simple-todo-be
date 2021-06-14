require 'rails_helper'

module Mutations
  module Categories
    RSpec.describe CreateCategory, type: :request do
      describe '.resolve' do
        it 'creates a category' do
          expect do
            post '/graphql', params: { query: query() }
          end.to change { Category.count }.by(1)
        end

        it 'returns a category' do
          post "/graphql", params: { query: query() }
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

      def query()
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