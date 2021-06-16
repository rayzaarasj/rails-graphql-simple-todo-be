# frozen_string_literal: true

require 'rails_helper'

module Mutations
  module Todos
    RSpec.describe CreateTodo, type: :request do
      describe '.resolve' do
        let(:category_1) do
          create(:category)
        end

        let(:category_2) do
          create(:category)
        end

        subject do
          post '/graphql', params: { query: query(category_ids: [category_1.id, category_2.id],
                                                  deadline: (DateTime.now + 1.day).to_s) }
          response
        end
        it 'creates a todo' do
          expect { subject }.to change { Todo.count }.by(1)
        end

        it 'returns a todo' do
          is_expected.to have_http_status :ok
          json = JSON.parse(response.body)
          data = json['data']['createTodo']

          expect(data).to include(
            'todo' => {
              'id' => be_present,
              'title' => 'test_title',
              'description' => 'test_description',
              'deadline' => (DateTime.now + 1.day).gmtime.strftime('%Y-%m-%dT%H:%M:%SZ').to_s,
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

      def query(category_ids:, deadline:)
        <<~GQL
          mutation{
            createTodo(input: {
              title: "test_title",
              description: "test_description",
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
