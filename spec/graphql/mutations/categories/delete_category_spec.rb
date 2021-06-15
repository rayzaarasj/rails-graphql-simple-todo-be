# frozen_string_literal: true

require 'rails_helper'

module Mutations
  module Categories
    RSpec.describe DeleteCategory, type: :request do
      describe '.resolve' do
        let(:category) do
          create(:category)
        end

        subject do
          post '/graphql', params: { query: query(category_id: category.id )}
          response
        end

        it 'deletes a category' do
          category
          expect { subject }.to change { Category.count }.by(-1)
        end

        it 'return a deleted category id' do
          is_expected.to have_http_status :ok
          json = JSON.parse(response.body)
          data = json['data']['deleteCategory']
          
          expect(data).to include(
            'deletedId' => category.id
          )
        end
      end

      def query(category_id:)
        <<~GQL
          mutation {
            deleteCategory(input:{
              id: #{category_id}
            }) {
              deletedId
            }
          }
        GQL
      end
    end
  end
end
