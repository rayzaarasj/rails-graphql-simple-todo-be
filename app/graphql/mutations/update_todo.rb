class Mutations::UpdateTodo < Mutations::BaseMutation
  argument :id, Integer, required: true
  argument :title, String, required: false
  argument :description, String, required: false
  argument :deadline, String, required: false
  argument :categories, [Integer], required: false

  field :todo, Types::TodoType, null: false
  field :errors, [String], null: false

  def resolve(id:, title:, description:, deadline:, categories:)
    todo = Todo.find(id)

    todo.title = title ? title : todo.title
    todo.description = description ? description : todo.description
    todo.deadline = deadline ? DateTime.strptime(deadline) : todo.deadline

    if categories
      todo.categories.clear
      categories.each do |categoryId|
        category = Category.find(categoryId)
        todo.categories << category
      end
    end

    if todo.save
      {
        todo: todo,
        errors: nil
      }
    else
      {
        todo: nil,
        errors: todo.errors.full_messages
      }
    end
  end 
end