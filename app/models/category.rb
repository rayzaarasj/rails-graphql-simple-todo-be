# frozen_string_literal: true

class Category < ApplicationRecord
<<<<<<< Updated upstream
    validates_presence_of :category
    has_and_belongs_to_many :todos
=======
  has_and_belongs_to_many :todos
>>>>>>> Stashed changes
end
