class Mutations::UpdateCategory < Mutations::BaseMutation
  argument :id, Integer, required: true
  argument :category, String, required: false

  field :category, Types::CategoryType, null: false
  field :errors, [String], null: false

  def resolve(id:, category:)
    categoryObject = Category.find(id)
    
    categoryObject.category = category ? category : categoryObject.category
    
    if categoryObject.save
      {
        category: categoryObject,
        errors: nil
      }
    else
      {
        category: nil,
        errors: categoryObject.errors.full_messages
      }
    end
  end
end