# frozen_string_literal: true

require 'rails_helper'

module Queries
  module Todos
    RSpec.describe Todos, type: :request do
      describe '.resolve' do
        let!(:category_1) { create(:category) }
        let!(:category_2) { create(:category) }
        let!(:todo) { create(:todo, categories: [category_1, category_2]) }

        subject do
          post '/graphql', params: { query: query(category_ids: [category_1.category, category_2.category]) }
          response
        end

        it 'returns the correct todos' do
          is_expected.to have_http_status :ok
          json = JSON.parse(response.body)
          data = json['data']['todosByCategoryNames']

          expect(data).to include(
            {
              'id' => "#{todo.id}",
              'title' => "#{todo.title}",
              'description' => "#{todo.description}",
              'deadline' => todo.deadline.gmtime.strftime('%Y-%m-%dT%H:%M:%SZ').to_s,
              'categories' => [
                {
                  'id' => category_1.id.to_s,
                  'category' => category_1.category
                },
                {
                  'id' => category_2.id.to_s,
                  'category' => category_2.category
                }
              ]
            }
          )
        end
      end

      def query(category_ids:)
        <<~GQL
          query {
            todosByCategoryNames(categoryNames:#{category_ids}) {
              id
              title
              description
              deadline
              categories {
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
