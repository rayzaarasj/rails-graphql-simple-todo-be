# frozen_string_literal: true

require 'rails_helper'

module Queries
  module Todos
    RSpec.describe Todos, type: :request do
      describe '.resolve' do
        let!(:todo) { create(:todo) }

        subject do
          post '/graphql', params: { query: query(title_substring: todo.title[rand(todo.title.length), rand(todo.title.length - 1) + 1]) }
          response
        end

        it 'returns the correct todo' do
          is_expected.to have_http_status :ok
          json = JSON.parse(response.body)
          data = json['data']['todosByTitle']

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

      def query(title_substring:)
        <<~GQL
          query {
            todosByTitle(title:"#{title_substring}") {
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
