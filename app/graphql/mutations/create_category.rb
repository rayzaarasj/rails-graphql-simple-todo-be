class Mutations::CreateCategory < Mutations::BaseMutation
  argument :category, String, required: true

  field :category, Types::CategoryType, null: false
  field :errors, [String], null: false

  def resolve(category:)
    category = Category.new(category: category)
    if category.save
      {
        category: category,
        errors: nil
      }
    else
      {
        todo: category,
        errors: category.errors.full_messages
      }
    end
  end
end