# frozen_string_literal: true

require 'rails_helper'

module Mutations
  module Todos
    RSpec.describe UpdateTodo, type: :request do
      describe '.resolve' do
        let!(:category_1) { create(:category) }
        let!(:category_2) { create(:category) }        
        let!(:category_3) { create(:category) }

        let!(:todo) do
          create(
            :todo,
            title: 'title_before',
            description: 'description_before',
            deadline: (DateTime.now + 1.day).to_s,
            categories: [category_1, category_2]
          )
        end

        subject do
          post '/graphql', params: { query: query(todo_id: todo.id, 
                                     category_ids:[category_2.id,category_3.id], 
                                     deadline:(DateTime.now + 2.day).to_s) }
          response
        end

        it 'updates a todo' do
          is_expected.to have_http_status :ok
          expect(todo.reload).to have_attributes(
            'title' => 'title_after',
            'description' => 'description_after',
            'deadline' => (DateTime.now + 2.day).gmtime.change(:usec => 0),
            'categories' => [category_2, category_3]
          )
        end

        it 'returns a todo' do
          is_expected.to have_http_status :ok
          json = JSON.parse(response.body)
          data = json['data']['updateTodo']

          expect(data).to include(
            'todo' => {
              'id' => "#{todo.id}",
              'title' => 'title_after',
              'description' => 'description_after',
              'deadline' => (DateTime.now + 2.day).gmtime.strftime('%Y-%m-%dT%H:%M:%SZ').to_s,
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

      def query(todo_id:, category_ids:, deadline:)
        <<~GQL
        mutation{
          updateTodo(input: {
            id: #{todo_id},
            title: "title_after",
            description: "description_after",
            deadline: "#{deadline}",
            categories: #{category_ids}
          }) {
            todo {
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
        }
        GQL
      end
    end
  end
end
