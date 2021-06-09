module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :todos, [Types::TodoType], null: true

    def todos
      a = Todo.all()
      puts a
      a
    end

    field :todo, [Types::TodoType], null: true do
      argument :title, String, required: false
    end

    def todo(title:)
      Todo.where("title = '" + title + "'")
    end

    field :todo_title, [Types::TodoType], null: true do
      argument :title, String, required: false
    end

    def todo_title(title:)
      result = Array.new()
      Todo.all.each do |todo|
        if todo.title.include?(title)
          result << todo
        end
      end
      return result
    end

    field :categories, [Types::CategoryType], null: true

    def categories
      Category.all()
    end

    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World!"
    end
  end
end
