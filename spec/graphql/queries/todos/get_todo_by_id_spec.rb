# frozen_string_literal: true

require 'rails_helper'

module Queries
  module Todos
    RSpec.describe Todos, type: :request do
      describe '.resolve' do
        let!(:todo) { create(:todo) }

        subject do
          post '/graphql', params: { query: query(todo_id: todo.id) }
          response
        end

        it 'returns the correct todo' do
          is_expected.to have_http_status :ok
          json = JSON.parse(response.body)
          data = json['data']['todoById']

          expect(data).to include(
            {
              'id' => "#{todo.id}",
              'title' => "#{todo.title}",
              'description' => "#{todo.description}",
              'deadline' => todo.deadline.gmtime.strftime('%Y-%m-%dT%H:%M:%SZ').to_s,
              'categories' => [
                {
                  'id' => todo.categories.first.id.to_s,
                  'category' => todo.categories.first.category
                }
              ]
            }
          )
        end
      end

      def query(todo_id:)
        <<~GQL
          query {
            todoById(id:#{todo_id}) {
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
