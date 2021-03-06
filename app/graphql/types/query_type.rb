# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :todos, [Types::TodoType], null: true

    def todos
      Todo.all
    end

    field :todos_by_title, [Types::TodoType], null: true do
      argument :title, String, required: true
    end

    def todos_by_title(title:)
      result = []
      Todo.all.each do |todo|
        result << todo if todo.title.downcase.include?(title.downcase)
      end
      result
    end

    field :todo_by_id, Types::TodoType, null: true do
      argument :id, Integer, required: true
    end

    def todo_by_id(id:)
      Todo.find(id)
    end

    # field :todo_by_categories, [Types::TodoType], null: true do
    #   argument :categories, [String], required: true
    # end

    # def todo_by_categories(categories:)
    #   result = Set.new
    #   categories.each do |category|
    #     categoryObject = Category.where("category = '#{category}'").first
    #     Todo.all.each do |todo|
    #       result << todo if todo.categories.include?(categoryObject)
    #     end
    #   end
    #   result
    # end

    field :todos_by_category_names, [Types::TodoType], null: true do
      argument :category_names, [String], required: true
    end

    def todos_by_category_names(category_names:)
      Todo.joins(:categories).distinct.where(categories: { category: category_names }).order('todos.deadline ASC')
    end

    field :todos_by_category_ids, [Types::TodoType], null: true do
      argument :category_ids, [Integer], required: true
    end

    def todos_by_category_ids(category_ids:)
      Todo.joins(:categories).distinct.where(categories: { id: category_ids }).order('todos.deadline ASC')
    end

    field :categories, [Types::CategoryType], null: true

    def categories
      Category.all
    end

    field :category_by_id, Types::CategoryType, null: true do
      argument :id, Integer, required: true
    end

    def category_by_id(id:)
      Category.find(id)
    end

    # TODO: remove me
    field :test_field, String, null: false,
                               description: 'An example field added by the generator'
    def test_field
      'Hello World!'
    end
  end
end
