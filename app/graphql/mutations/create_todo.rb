class Mutations::CreateTodo < Mutations::BaseMutation
  argument :title, String, required: true
  argument :description, String, required: true
  argument :deadline, String, required: true
  argument :categories, [Integer], required: true

  field :todo, Types::TodoType, null: false
  field :errors, [String], null: false

  def resolve(title:, description:, deadline:, categories:)
    todo = Todo.new(title: title, description: description, deadline: DateTime.strptime(deadline))
    categories.each do |categoryId|
      category = Category.find(categoryId)
      todo.categories << category 
    end
    if todo.save
      {
        todo: todo,
        errors: nil
      }
    else
      {
        todo: nil,
        errors: user.errors.full_messages
      }
    end
  end
end