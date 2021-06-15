# frozen_string_literal: true
require 'rails_helper'

module Mutations
  module Categories
    RSpec.describe UpdateCategory, type: :request do
      describe '.resolve' do
        let(:category) do
          create(:category, category: "category_before")
        end
  
        subject do
          post '/graphql', params: { query: query(category_id: category.id) }
          response
        end

        it 'updates a category' do
          is_expected.to have_http_status :ok
          expect(category.reload).to have_attributes(
            'id' => category.id,
            'category' => 'category_after'
          )
        end

        it 'returns a category' do
          is_expected.to have_http_status :ok
          json = JSON.parse(response.body)
          data = json['data']['updateCategory']

          expect(data).to include(
            'category' => {
              'id' => "#{category.id}",
              'category' => 'category_after'
            }
          )
        end
      end
      
      def query(category_id:)
        <<~GQL
            mutation{
              updateCategory(input: {
                id: #{category_id},
                category: "category_after",
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
