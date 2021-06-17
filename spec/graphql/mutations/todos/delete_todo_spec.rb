# frozen_string_literal: true

require 'rails_helper'

module Mutations
  module Todos
    RSpec.describe DeleteTodo, type: :request do
      describe '.resolve' do
        let(:todo) do
          create(:todo)
        end

        subject do
          post '/graphql', params: { query: query(todo_id: todo.id) }
          response
        end

        it 'deletes a todo' do
          todo
          expect { subject }.to change { Todo.count }.by(-1)
        end

        it 'returns a deleted todo id' do
          is_expected.to have_http_status :ok
          json = JSON.parse(response.body)
          data = json['data']['deleteTodo']
          
          expect(data).to include(
            'deletedId' => todo.id
          )
        end
      end

      def query(todo_id:)
        <<~GQL
          mutation {
            deleteTodo(input:{
              id: #{todo_id}
            }) {
              deletedId
            }
          }
        GQL
      end
    end
  end
end
