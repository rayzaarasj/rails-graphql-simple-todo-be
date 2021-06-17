# frozen_string_literal: true

require 'rails_helper'

module Queries
  module Todos
    RSpec.describe Todos, type: :request do
      describe '.resolve' do
        let!(:category_1) { create(:category) }
        let!(:category_2) { create(:category) }
        let!(:category_3) { create(:category) }
        let!(:todo_1) { create(:todo, categories: [category_1, category_2]) }
        let!(:todo_2) { create(:todo, categories: [category_2, category_3]) }

        subject do
          post '/graphql', params: { query: query() }
          response
        end

        it 'returns all todos' do
          is_expected.to have_http_status :ok
          json = JSON.parse(response.body)
          data = json['data']['todos']

          expect(data).to include(
            {
              'id' => "#{todo_1.id}",
              'title' => "#{todo_1.title}",
              'description' => "#{todo_1.description}",
              'deadline' => todo_1.deadline.gmtime.strftime('%Y-%m-%dT%H:%M:%SZ').to_s,
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
            },
            {
              'id' => "#{todo_2.id}",
              'title' => "#{todo_2.title}",
              'description' => "#{todo_2.description}",
              'deadline' => todo_2.deadline.gmtime.strftime('%Y-%m-%dT%H:%M:%SZ').to_s,
              'categories' => [
                {
                  'id' => category_2.id.to_s,
                  'category' => category_2.category
                },
                {
                  'id' => category_3.id.to_s,
                  'category' => category_3.category
                }
              ]
            }
          )
        end
      end

      def query
        <<~GQL
          query {
            todos {
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
