# frozen_string_literal: true

class CreateTodosCategoriesJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_join_table :categories, :todos
  end
end
