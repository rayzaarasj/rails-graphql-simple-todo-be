# frozen_string_literal: true

module Mutations
  class DeleteCategory < Mutations::BaseMutation
    argument :id, Integer, required: true

    field :deletedId, Integer, null: false
    field :errors, [String], null: false

    def resolve(id:)
      category = Category.find(id)

      if category.destroy
        {
          deletedId: id,
          errors: nil
        }
      else
        {
          deletedId: nil,
          errors: category.errors.full_messages
        }
      end
    end
  end
end
