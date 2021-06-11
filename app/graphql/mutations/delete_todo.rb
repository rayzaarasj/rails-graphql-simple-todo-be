class Mutations::DeleteTodo < Mutations::BaseMutation
  argument :id, Integer, required: true

  field :deletedId, Integer, null: false
  field :errors, [String], null: false

  def resolve(id:)
    todo = Todo.find(id)

    if todo.destroy
      {
        deletedId: id,
        errors: nil
      }
    else
      {
        deletedId: nil,
        errors: todo.errors.full_messages
      }
    end
  end
end